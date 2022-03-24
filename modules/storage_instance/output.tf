###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# Storage server outputs
###################################################

# NFS Private IP
output "nfs_private_ip" {
  description = "SSH commend for Storage Server"
  value       = ibm_is_instance.storage_instance.primary_network_interface[0].primary_ipv4_address
}