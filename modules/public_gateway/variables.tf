###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# Public Gateway variables.
###################################################

variable "resource_group" {
  description = "Resource Group ID is used to seperate the resources in a group."
  type        = string
}

variable "prefix" {
  description = "Prefix for all the resources."
  type        = string
}

variable "vpc_id" {
  description = "Required parameter vpc_id"
  type        = string
}

variable "zones" {
  description = "List of Availability Zones where compute resource will be created"
  type        = list(any)
}

variable "tags" {
  description = "Add tag names to the cluster resources"
  type        = list
}