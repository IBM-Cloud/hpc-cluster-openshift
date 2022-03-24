###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# Subnet Variables.
###################################################

variable "ip_count" {
  description = "Enter total number of IP Address for each subnet"
  type        = any
}

variable "resource_group" {
  description = "Resource Group Name is used to seperated the resources in a group."
  type        = string
}

variable "prefix" {
  description = "Prefix for all the resources."
  type        = string
}

variable "vpc_id" {
  description = "Required parameter vpc_id"
  type        = any
}

variable "zones" {
  description = "List of Availability Zones where compute resource will be created"
  type        = list(any)
}

variable "public_gateway_ids" {
  description = "List of ids of all the public gateways where subnets will get attached"
  type        = list(any)
}

variable "tags" {
  description = "Add tag names to the cluster resources"
  type        = list
}