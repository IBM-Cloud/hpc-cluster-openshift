###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
###################################################

# Local Variables
locals {
  ssh_key_list = split(",", var.ssh_key_name)
  ssh_key_id_list = [
    for name in local.ssh_key_list :
    data.ibm_is_ssh_key.ssh_key[name].id
  ]

  zones = {
    "us-south" = ["us-south-1", "us-south-2", "us-south-3"] #Dallas
    "us-east"  = ["us-east-1", "us-east-2", "us-east-3"]    #Washington DC
    "eu-gb"    = ["eu-gb-1", "eu-gb-2", "eu-gb-3"]          #London
    "eu-de"    = ["eu-de-1", "eu-de-2", "eu-de-3"]          #Frankfurt
    "jp-tok"   = ["jp-tok-1", "jp-tok-2", "jp-tok-3"]       #Tokyo
    "au-syd"   = ["au-syd-1", "au-syd-2", "au-syd-3"]       #Sydney
    "jp-osa"   = ["jp-osa-1", "jp-osa-2", "jp-osa-3"]       #Osaka
    "br-sao"   = ["br-sao-1", "br-sao-2", "br-sao-3"]       #Sao Paulo
    "ca-tor"   = ["ca-tor-1", "ca-tor-2", "ca-tor-3"]       #Toronto
  }

  script_map = {
    "login"   = file("./scripts/login_server_pre_requirements.sh")
    "storage" = file("${path.module}/scripts/user_data_input_storage.tpl")
  }

  login_template_file   = lookup(local.script_map, "login")
  storage_template_file = lookup(local.script_map, "storage")
  image_id              = "ibm-redhat-8-4-minimal-amd64-2"
  tags                  = ["hpcc", var.cluster_prefix]
  cluster_name          = "${var.cluster_prefix}-${var.region}-cluster"
  
}

# Get Resource Group ID
data "ibm_resource_group" "res_grp" {
  name = var.resource_group
}

# Get the list of SSH key ID's
data "ibm_is_ssh_key" "ssh_key" {
  for_each = toset(split(",", var.ssh_key_name))
  name     = each.value
}

# Login server userdata
data "template_file" "login_user_data" {
  template = local.login_template_file
}

# Storage server userdata
data "template_file" "storage_user_data" {
  template = local.storage_template_file
  vars = {
    mount_path = var.mount_path
  }
}

# Get Volume profile
data "ibm_is_volume_profile" "nfs" {
  name = var.volume_profile
}

# Get the RHEL ImageID
data "ibm_is_image" "stock_image" {
  name = local.image_id
}

# Create COS instance
resource "ibm_resource_instance" "cos_instance" {
  name              = "${var.cluster_prefix}-cos"
  resource_group_id = data.ibm_resource_group.res_grp.id
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
}

# Create a VPC
resource "ibm_is_vpc" "vpc" {
  name           = "${var.cluster_prefix}-vpc"
  resource_group = data.ibm_resource_group.res_grp.id
  tags           = local.tags
}

# Create a Public Gateway
module "public_gateway" {
  source         = "./modules/public_gateway"
  vpc_id         = ibm_is_vpc.vpc.id
  prefix         = var.cluster_prefix
  resource_group = data.ibm_resource_group.res_grp.id
  zones          = local.zones[var.region]
  tags           = local.tags
  depends_on     = [ibm_is_vpc.vpc]
}

# Create and Assign Subnet to VPC
module "subnet" {
  source             = "./modules/subnets"
  vpc_id             = ibm_is_vpc.vpc.id
  prefix             = var.cluster_prefix
  zones              = local.zones[var.region]
  resource_group     = data.ibm_resource_group.res_grp.id
  ip_count           = "1024"
  public_gateway_ids = module.public_gateway.pg_ids
  tags               = local.tags
  depends_on         = [ibm_is_vpc.vpc, module.public_gateway]
}

# Create a Login VSI
module "login_server" {
  source         = "./modules/login_server"
  prefix         = var.cluster_prefix
  region         = var.region
  vpc_id         = ibm_is_vpc.vpc.id
  login_ssh_key  = local.ssh_key_id_list
  resource_group = data.ibm_resource_group.res_grp.id
  zones          = local.zones[var.region]
  login_image    = data.ibm_is_image.stock_image.id
  login_profile  = var.login_node_instance_type
  user_data      = data.template_file.login_user_data.rendered
  tags           = local.tags
  depends_on     = [ibm_is_vpc.vpc]
}

# Create a NFS storage server
module "storage_instance" {
  source             = "./modules/storage_instance"
  prefix             = var.cluster_prefix
  region             = var.region
  vpc_id             = ibm_is_vpc.vpc.id
  storage_ssh_key    = local.ssh_key_id_list
  resource_group     = data.ibm_resource_group.res_grp.id
  zones              = local.zones[var.region]
  public_gateway_ids = module.login_server.login_pg_id
  volume_capacity    = var.volume_capacity
  volume_profile     = data.ibm_is_volume_profile.nfs.name
  volume_iops        = data.ibm_is_volume_profile.nfs.name == "custom" ? var.volume_iops : null
  storage_image      = data.ibm_is_image.stock_image.id
  storage_profile    = var.storage_node_instance_type
  security_group_id  = module.login_server.login_sg_id
  user_data          = "${data.template_file.storage_user_data.rendered} ${file("${path.module}/scripts/user_data_storage.sh")}"
  tags               = local.tags
  depends_on         = [ibm_is_vpc.vpc]
}

# Create a VPC based OpenShift Multi-Zone cluster
module "vpc_openshift_cluster" {
  source                = "./modules/openshift"
  cluster_name          = local.cluster_name
  region                = var.region
  zones                 = local.zones[var.region]
  vpc_id                = ibm_is_vpc.vpc.id
  worker_pool_flavor    = var.worker_pool_flavor
  resource_group_id     = data.ibm_resource_group.res_grp.id
  kube_version          = var.kube_version
  worker_zone           = module.subnet.subnet_ids
  cos_instance_crn      = ibm_resource_instance.cos_instance.crn
  worker_nodes_per_zone = var.worker_nodes_per_zone
  tags                  = local.tags
  depends_on            = [ibm_is_vpc.vpc, module.subnet.ibm_is_subnet]
}

# OpenShift Monitoring
module "openshift_monitoring" {
  count             = var.enable_monitoring == true ? 1 : 0
  source            = "./modules/openshift_monitoring"
  cluster           = local.cluster_name
  region            = var.region
  resource_group_id = data.ibm_resource_group.res_grp.id
  depends_on        = [module.vpc_openshift_cluster]
}

# OpenShift LogDNA
module "openshift_logdna" {
  count             = var.enable_logdna == true ? 1 : 0
  source            = "./modules/openshift_logdna"
  cluster           = local.cluster_name
  region            = var.region
  resource_group_id = data.ibm_resource_group.res_grp.id
  depends_on        = [module.vpc_openshift_cluster]
}