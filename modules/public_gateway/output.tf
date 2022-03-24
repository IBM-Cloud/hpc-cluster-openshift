###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# Public Gateway outputs
###################################################

# List of Public Gateway ID's
output "pg_ids" {
  value = ibm_is_public_gateway.pg.*.id
}