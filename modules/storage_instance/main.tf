###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# NFS Storage server Resources.
###################################################

/**
* Subnet for nfs storage server 
* Element : subnet
* This resource will be used to create a subnet for Storage server.
**/
resource "ibm_is_subnet" "nfs_sub" {
  name                     = "${var.prefix}-nfs-subnet"
  vpc                      = var.vpc_id
  zone                     = element(var.zones, 0)
  total_ipv4_address_count = 8
  resource_group           = var.resource_group
  public_gateway           = var.public_gateway_ids[0]
  tags                     = var.tags
}

/**
* Security Group for NFS Storage server
* Element : sg 
* Defining resource "Security Group". This will be responsible to handle security for the 
* Storage Server
**/
resource "ibm_is_security_group" "sg" {
  name           = "${var.prefix}-storage-sg"
  vpc            = var.vpc_id
  resource_group = var.resource_group
  tags           = var.tags
}

/**
* Security Group Rule for NFS Server
* This inbound rule will allow the user to ssh connect to the NFS server on port 22 from their local machine.
**/
resource "ibm_is_security_group_rule" "ssh_inbound" {
  group     = ibm_is_security_group.sg.id
  direction = "inbound"
  remote    = var.security_group_id
  tcp {
    port_min = "22"
    port_max = "22"
  }
}

/**
* Security Group inbound rule for NFS Server
* This inbound rule will allow the user to access NFS shared folder.
**/
resource "ibm_is_security_group_rule" "nfs_inbound" {
  group     = ibm_is_security_group.sg.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = "2049"
    port_max = "2049"
  }
}

/**
* Security Group oubound rule for NFS Server
* This outbound rule will allow the user traffic go out.
**/
resource "ibm_is_security_group_rule" "nfs_outbound" {
  group     = ibm_is_security_group.sg.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

/**
* Create a Vloume and attch to NFS server
* Element : Volume
**/
resource "ibm_is_volume" "nfs" {
  name           = "${var.prefix}-nfs-volume"
  profile        = var.volume_profile
  capacity       = var.volume_capacity
  iops           = var.volume_iops
  zone           = element(var.zones, 0)
  resource_group = var.resource_group
  tags           = var.tags
}

/**
* Virtual Server Instance for NFS Server
* Element : VSI
**/
resource "ibm_is_instance" "storage_instance" {
  name           = "${var.prefix}-nfs-storage"
  keys           = var.storage_ssh_key
  image          = var.storage_image
  profile        = var.storage_profile
  resource_group = var.resource_group
  vpc            = var.vpc_id
  zone           = element(var.zones, 0)
  volumes        = [ibm_is_volume.nfs.id]
  user_data      = var.user_data
  tags           = var.tags

  primary_network_interface {
    subnet          = ibm_is_subnet.nfs_sub.id
    security_groups = [ibm_is_security_group.sg.id]
  }

  # lifecycle {
  #   prevent_destroy = false // TODO: Need to toggle this variable before publishing the script.
  #   ignore_changes = [
  #     user_data,
  #   ]
  # }
}
