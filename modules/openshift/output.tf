###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# OpenShift cluster output details.
###################################################

output "url" {
  value = ibm_container_vpc_cluster.cluster.master_url
}

output "public_service_endpoint_url" {
  value = ibm_container_vpc_cluster.cluster.public_service_endpoint_url
}

output "ingress_subdomain" {
  value = ibm_container_vpc_cluster.cluster.ingress_hostname
}

