###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# OpenShift Monitoring variables.
###################################################

variable "cluster" {
  description = "Name of the OpenShift cluster"
  type        = string
}

variable "region" {
  description = "Name of the Region."
  type        = string
}

variable "resource_group_id" {
  description = "ID of resource group."
  type        = string
}

variable "create_timeout" {
  description = "Timeout duration for create."
  type        = string
  default     = "45m"
}

variable "update_timeout" {
  description = "Timeout duration for update."
  type        = string
  default     = "10m"
}

variable "delete_timeout" {
  description = "Timeout duration for delete."
  type        = string
  default     = "10m"
}

variable "private_endpoint" {
  description = "Add this option to connect to your LogDNA service instance through the private service endpoint"
  type        = bool
  default     = null
}

variable "sysdig_access_key" {
  type        = string
  description = "sysdig access key."
  default     = null
}
