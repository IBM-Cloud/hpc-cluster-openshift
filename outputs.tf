###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# OpenShift cluster Outputs
###################################################

/**
*   Login Server IP Address.
**/
output "login_ssh_command" {
  description = "Login sever SSH comand"
  value       = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@${module.login_server.login_ip_addr}"
}

/**
*   NFS Server IP Address.
**/
output "nfs_ssh_command" {
  description = "Storage Server SSH command"
  value       = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -J root@${module.login_server.login_ip_addr} root@${module.storage_instance.nfs_private_ip}"
}

/**
*   Optput of OpenShift URL to access it from Browser.
**/
output "openshift_url" {
  description = "OpenShift URL"
  value       = "https://console-openshift-console.${module.vpc_openshift_cluster.ingress_subdomain}/dashboards"
}

/**
*   Optput of LogDNA URL to access it from Browser.
**/
output "logdna_url" {
  description = "LogDNA URL"
  value       = module.openshift_logdna[*].logdna_url
}

/**
*   Optput of Monitoring URL to access it from Browser.
**/
output "monitoring_url" {
  description = "Monitoring URL"
  value       = module.openshift_monitoring[*].monitoring_url
}
