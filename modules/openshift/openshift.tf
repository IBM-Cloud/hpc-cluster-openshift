###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# OpenShift cluster resources
###################################################

/**
* Openshift resource for cluster creation
* Element : cluster
* This resource will be used to create OpenShift Cluster with required worker nodes.
**/
resource "ibm_container_vpc_cluster" "cluster" {
  name                 = var.cluster_name
  vpc_id               = var.vpc_id
  flavor               = var.worker_pool_flavor
  kube_version         = var.kube_version
  service_subnet       = "172.21.0.0/16"
  worker_count         = var.worker_nodes_per_zone
  cos_instance_crn     = var.cos_instance_crn
  resource_group_id    = var.resource_group_id
  wait_till            = "ingressReady"
  tags                 = var.tags

  dynamic "zones" {
    for_each = (var.worker_zone != null ? var.worker_zone : [])
    content {
      name      = "${var.region}-${zones.key + 1}"
      subnet_id = zones.value
    }
  }

  timeouts {
    create = "120m"
    update = "80m"
    delete = "45m"
  }
}