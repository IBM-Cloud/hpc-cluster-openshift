###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# OpenShift LogDNA 
###################################################

# OpenShift Monitoring INstance
resource "ibm_resource_instance" "logdna_instance" {
  name              = "openshift_logdna"
  service           = "logdna"
  resource_group_id = var.resource_group_id
  plan              = "7-day"
  location          = var.region
}

resource "ibm_resource_key" "resourceKey" {
  name                 = "TestKey"
  resource_instance_id = ibm_resource_instance.logdna_instance.id
  role                 = "Manager"
}

resource "ibm_ob_logging" "logging" {
  cluster              = var.cluster
  instance_id          = ibm_resource_instance.logdna_instance.guid
  private_endpoint     = var.private_endpoint != null ? var.private_endpoint : null
  logdna_ingestion_key = var.logdna_ingestion_key != null ? var.logdna_ingestion_key : null
  depends_on           = [ibm_resource_key.resourceKey]

  timeouts {
    create = (var.create_timeout != null ? var.create_timeout : null)
    update = (var.update_timeout != null ? var.update_timeout : null)
    delete = (var.delete_timeout != null ? var.delete_timeout : null)
  }
}