###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# Public GAteway resources
###################################################

/**
* Public Gateway for all subnets in all availability zones
* Element : pg
* This resource will be used to create the Public gateway in all availability zones
**/
resource "ibm_is_public_gateway" "pg" {
  count          = length(var.zones)
  name           = "${var.prefix}-gateway-${count.index + 1}"
  vpc            = var.vpc_id
  zone           = var.zones[count.index]
  resource_group = var.resource_group
  tags           = var.tags
}