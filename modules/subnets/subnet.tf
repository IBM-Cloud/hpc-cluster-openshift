###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# Subnet Resources.
###################################################

/**
* Subnet for OpenShift Cluster
* Element : subnet
* This resource will be used to create a subnet for OpenShift Cluster.
**/
resource "ibm_is_subnet" "subnet" {
  count                    = length(var.zones)
  name                     = "${var.prefix}-zone-${count.index + 1}-sub"
  vpc                      = var.vpc_id
  resource_group           = var.resource_group
  zone                     = var.zones[count.index]
  public_gateway           = var.public_gateway_ids[count.index]
  total_ipv4_address_count = var.ip_count
  tags                     = var.tags
}
