###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
###################################################

# Terraform Cloud Providers
terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.31.0"
    }
  }
}

# IBM provider variables
provider "ibm" {
  ibmcloud_api_key = var.api_key
  region           = var.region
  ibmcloud_timeout = 300
}