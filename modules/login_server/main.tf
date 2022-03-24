###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# Login_Server Module Resources
###################################################

/**
* Subnet for Login Server or Jump Server
* Element : subnet
* This resource will be used to create a subnet for Login Server.
**/
resource "ibm_is_subnet" "login_sub" {
  name                     = "${var.prefix}-login-subnet"
  vpc                      = var.vpc_id
  zone                     = element(var.zones, 0)
  total_ipv4_address_count = 8
  resource_group           = var.resource_group
  tags                     = var.tags
  public_gateway           = ibm_is_public_gateway.pg.*.id[0]
}

/**
* Public Gateway for Login Server or Jump Server
* Element : public_gateway
* This resource will be used to create a Public Gateway for Login Server.
**/
resource "ibm_is_public_gateway" "pg" {
  name           = "${var.prefix}-login-pg"
  vpc            = var.vpc_id
  zone           = element(var.zones, 0)
  tags           = var.tags
  resource_group = var.resource_group
}

/**
* Security Group for Login Server
* Defining resource "Security Group". This will be responsible to handle security for the 
* login Server
**/
resource "ibm_is_security_group" "login_sg" {
  name           = "${var.prefix}-login-sg"
  vpc            = var.vpc_id
  tags           = var.tags
  resource_group = var.resource_group
}

/**
* Security Group Rule for Login Server
* This inbound rule will allow the user to ssh connect to the login server on port 22 from their local machine.
**/
resource "ibm_is_security_group_rule" "login_inbound" {
  group     = ibm_is_security_group.login_sg.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = "22"
    port_max = "22"
  }
}

/**
* Security Group Outbound Rule for Login Server
**/
resource "ibm_is_security_group_rule" "login_outbound" {
  group     = ibm_is_security_group.login_sg.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
}

/**
* Floating IP address for Login Server or Jump Server. This is the static public IP attached to the login server. User will use this floating IP to ssh connect to the 
* login server from their local machine.
* Element : Floating IP
* This resource will be used to attach a floating IP address.
**/
resource "ibm_is_floating_ip" "login_floating_ip" {
  name           = "${var.prefix}-login-fip"
  resource_group = var.resource_group
  target         = ibm_is_instance.login.primary_network_interface.0.id
  tags           = var.tags
  depends_on     = [ibm_is_instance.login]
}

/**
* Virtual Server Instance for Login Server or Jump Server
* Element : VSI
* We are creating a login server or jump server along with the floating IP. The login server is mainly used to maintain the server and other 
* cloud resources within the same VPC. It is used to secure other servers to only allow access from login server. 
* As this login server is very important to access other VSI. So to prevent the accidental 
* deletion of this server we are adding a lifecycle block with prevent_destroy=true flag to 
* protect this. If you want to delete this server then before executing terraform destroy, please update prevent_destroy=false.
**/
resource "ibm_is_instance" "login" {
  name           = "${var.prefix}-login-vsi"
  keys           = var.login_ssh_key
  image          = var.login_image
  profile        = var.login_profile
  resource_group = var.resource_group
  vpc            = var.vpc_id
  zone           = element(var.zones, 0)
  user_data      = var.user_data
  tags           = var.tags

  primary_network_interface {
    subnet          = ibm_is_subnet.login_sub.id
    security_groups = [ibm_is_security_group.login_sg.id]
  }

  # lifecycle {
  #   prevent_destroy = false // TODO: Need to toggle this variable before publishing the script.
  #   ignore_changes = [
  #     user_data,
  #   ]
  # }
}