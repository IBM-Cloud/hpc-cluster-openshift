###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# Login_Server Output details.
###################################################

output "login_ip_addr" {
  description = "SSH commend for Login Server"
  value       = ibm_is_floating_ip.login_floating_ip.address
}

output "login_pg_id" {
  description = "Public Gateway Id's"
  value       = ibm_is_public_gateway.pg.*.id
}

output "login_sg_id" {
  value       = ibm_is_security_group.login_sg.id
  description = "login | Jumphost security group ID"
}