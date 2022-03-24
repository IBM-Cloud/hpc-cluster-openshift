###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# OpenShift cluster Monitoring
###################################################

# OpenShift Monitoring
resource "ibm_resource_instance" "sysdig_instance" {
  name              = "openshift_monitoring"
  service           = "sysdig-monitor"
  resource_group_id = var.resource_group_id
  plan              = "graduated-tier"
  location          = var.region
}

resource "ibm_resource_key" "resourceKey" {
  name                 = "openshift-key"
  resource_instance_id = ibm_resource_instance.sysdig_instance.id
  role                 = "Manager"
}

resource "ibm_ob_monitoring" "sysdig" {
  cluster           = var.cluster
  instance_id       = ibm_resource_instance.sysdig_instance.guid
  sysdig_access_key = var.sysdig_access_key != null ? var.sysdig_access_key : null
  private_endpoint  = var.private_endpoint != null ? var.private_endpoint : null

  timeouts {
    create = (var.create_timeout != null ? var.create_timeout : null)
    update = (var.update_timeout != null ? var.update_timeout : null)
    delete = (var.delete_timeout != null ? var.delete_timeout : null)
  }
}