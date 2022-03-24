###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# Storage Server variables.
###################################################

variable "region" {
  description = "Get your Region"
  type        = string
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

variable "storage_ssh_key" {
  description = "List of SSH key ID's"
  type        = list(any)
}

variable "storage_image" {
  description = "NFS Storage VSI Image"
  type        = string
}

variable "storage_profile" {
  description = "Your Server Flavour"
  type        = string
}

variable "zones" {
  description = "List of Availability Zones where compute resource will be created"
  type        = list(any)
}

variable "public_gateway_ids" {
  description = "List of ids of all the public gateways where subnets will get attached"
  type        = list(any)
}

variable "volume_capacity" {
  description = "Required NFS volume storage capacity in GB's"
  type        = number
}

variable "user_data" {
  description = "Calling user_data script"
  type        = string
}

variable "volume_profile" {
  type        = string
  description = "Enter you Volume profile details."
}

variable "volume_iops" {
  type        = number
  description = "Number to represent the IOPS "
}

variable "security_group_id" {
  type        = string
  description = "Allowing this security groups to connect NFS server."
}

variable "tags" {
  description = "Add tag names to the cluster resources"
  type        = list
}