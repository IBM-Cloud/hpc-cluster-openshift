###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# OpenShift Monitoring outputs
###################################################

# Monitoring URL
output "monitoring_url" {
  description = "Monitoring URL for Openshift cluster"
  value       = ibm_resource_instance.sysdig_instance.dashboard_url
}
