###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
# OpenShift Login server variables.
###################################################

variable "region" {
  description = "Enter a region from the following available region and zones mapping: \nus-south\nus-east\neu-gb\neu-de\njp-tok\nau-syd\njp-osa\nbr-sao\nca-tor.Find the region details [here](https://cloud.ibm.com/docs/overview?topic=overview-locations)."
  type        = string
}

variable "resource_group" {
  description = "Resource Group Id is used to seperated the resources in a group."
  type        = string
}

variable "prefix" {
  description = "Prefix that is used to name the OpenShift cluster and IBM Cloud resources that are provisioned to build the OpenShift cluster instance. You cannot create more than one instance of the OpenShift cluster with the same name. Make sure that the name is unique. Enter a prefix name, such as my-openshift. Length of prefix should be less than 13 characters."
  type        = string
}

variable "vpc_id" {
  description = "This is the vpc id which will be used for Login Server module. We are passing this vpc_id from main.tf"
  type        = any
}

variable "login_ssh_key" {
  description = "List of SSH key ID's"
  type        = list(any)
}

variable "login_image" {
  description = "Image ID of Login server"
  type        = string
}

variable "login_profile" {
  description = "Your Server Flavour for Login server"
  type        = string
}

variable "zones" {
  description = "List of Availability Zones where compute resource will be created"
  type        = list(any)
}

variable "user_data" {
  description = "Userdata script for Login Server"
  type        = string
}

variable "tags" {
  description = "Add Cluster resource tags to the OpenShift cluster resources"
  type        = list
}