###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# Subnet Outputs
###################################################

# List of Subnet ID's
output "subnet_ids" {
  value       = ibm_is_subnet.subnet.*.id
  description = "Subnet ids of all zones"
}