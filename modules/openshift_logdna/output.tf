###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# OpenShift LogDNA outputs
###################################################

# LogDNA URL
output "logdna_url" {
  description = "LogDNA URL for Openshift cluster"
  value       = ibm_resource_instance.logdna_instance.dashboard_url
}