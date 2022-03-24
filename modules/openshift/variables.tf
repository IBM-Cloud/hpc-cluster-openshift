###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# OpenShift cluster variables
###################################################

variable "cluster_name" {
  description = "Name of the cluster."
  type        = string
}

variable "region" {
  description = "Enter a region from the following available region and zones mapping: \nus-south\nus-east\neu-gb\neu-de\njp-tok\nau-syd\njp-osa\nbr-sao\nca-tor.Find the region details [here](https://cloud.ibm.com/docs/overview?topic=overview-locations)."
  type        = string
}

variable "vpc_id" {
  description = "This is the vpc id which will be used for Login Server module. We are passing this vpc_id from main.tf"
  type        = string
}

variable "worker_pool_flavor" {
  description = "The flavor of the OpenShift worker node that you want to use."
  type        = string
}

variable "kube_version" {
  description = "The Kubernetes or OpenShift version that you want to set up in your cluster."
  type        = string
}

variable "worker_nodes_per_zone" {
  description = "The number of worker nodes per zone in the default worker pool."
  type        = number
}

variable "resource_group_id" {
  description = "ID of resource group."
  type        = string
}

variable "cos_instance_crn" {
  description = "Enable openshift entitlement during cluster creation."
  type        = string
}

variable "worker_zone" {
  description = "List of Availability Zones where compute resource will be created."
  type        = list(any)
}

variable "zones" {
  description = "List of Availability Zones where compute resource will be created."
  type        = list(any)
}

variable "tags" {
  description = "Add tag names to the cluster resources."
  type        = list
}