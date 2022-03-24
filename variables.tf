###################################################
# Copyright (C) IBM Corp. 2022 All Rights Reserved.
# Licensed under the Apache License v2.0
###################################################

##################################################
##############      VPC Variables        #########
##################################################

variable "api_key" {
  type        = string
  description = "This is the API key for IBM Cloud account in which the Red Hat OpenShift cluster needs to be deployed.  For more information on how to create an API key, see [Managing user API keys](https://cloud.ibm.com/docs/account?topic=account-userapikey)."
  sensitive   = true
  validation {
    condition     = var.api_key != ""
    error_message = "API key for IBM Cloud must be set."
  }
}

variable "region" {
    type        = string
    description = "Enter a region from the following list in which the cluster will be deployed: us-south, us-east, eu-gb, eu-de, jp-tok, au-syd, jp-osa, br-sao, ca-tor. For more information, see [Region and data center locations for resource deployment](https://cloud.ibm.com/docs/overview?topic=overview-locations)."

    validation  {
      error_message = "Must use an IBM Cloud region. Use `ibmcloud regions` with the IBM Cloud CLI to see valid regions."
      condition     = contains([
          "au-syd",
          "jp-tok",
          "eu-de",
          "eu-gb",
          "us-south",
          "us-east",
          "jp-osa",
          "br-sao",
          "ca-tor"
        ], var.region)
    }
}

variable "resource_group" {
  type        = string
  default     = "Default"
  description = "Resource group name from your IBM Cloud account where the VPC resources should be deployed. For more information, see [Managing resource groups](https://cloud.ibm.com/docs/account?topic=account-rgs)."
}

variable "cluster_prefix" {
  type        = string
  default     = "hpcc-oc"
  description = "Prefix that is used to name the IBM Cloud resources that are provisioned to build the Red Hat OpenShift cluster.  You cannot create more than one instance of the Red Hat OpenShift cluster with the same name. Make sure that the name is unique. Enter a prefix name, for example, 'my-openshift'.  The length of the prefix should be fewer than 13 characters."
  validation {
    condition     = length(var.cluster_prefix) <= 13
    error_message = "Length of prefix should be less than 13 characters."
  }
  validation {
    condition     = can(regex("^[a-z][-0-9a-z]*$", var.cluster_prefix))
    error_message = "The prefix should start with a small case character in between a-z. In between we can use 0-9 values."
  }
}

variable "ssh_key_name" {
  type        = string
  description = "Comma-separated list of names of the SSH key configured in your IBM Cloud account that is used to establish a connection to the Red Hat OpenShift login node. Ensure that the SSH key is present in the same resource group and region where the cluster is being provisioned. If you do not have an SSH key in your IBM Cloud account, create one by using the [SSH keys](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys) instructions."
}

##################################################
#######   OpenShift Cluster  Variables    ########
##################################################

variable "kube_version" {
  type        = string
  description = "The Red Hat OpenShift version that you want to set up in your cluster. Available versions:   4.9_openshift and 4.8_openshift.  For more information, see [Version information and update actions](https://cloud.ibm.com/docs/openshift?topic=openshift-openshift_versions)."
  default     = "4.9_openshift"
  validation {
    condition     = contains(["4.9_openshift","4.8_openshift"], var.kube_version)
    error_message = "Please Enter Latest version. Avilable values are 4.8_openshift and 4.9_openshift."
  }
}

variable "worker_pool_flavor" {
  type        = string
  default     = "bx2.4x16"
  description = "The flavor of the Red Hat OpenShift worker nodes that you want to create and attach to the cluster. For more information, see [Available flavors for VMs](https://cloud.ibm.com/docs/openshift?topic=openshift-planning_worker_nodes#vm-table)."
}

variable "worker_nodes_per_zone" {
  type        = number
  description = "The number of worker nodes per zone in the default worker pool. Minimum is one node, and 1,000 is the maximum for each zone. For more information, see [Planning your worker node setup](https://cloud.ibm.com/docs/openshift?topic=openshift-planning_worker_nodes)."
  default     = 1
  validation {
    condition     = 1 <= var.worker_nodes_per_zone && var.worker_nodes_per_zone <= 1000
    error_message = "Input \"worker_nodes_per_zone\" must be >= 1 and <= 1000."
  }
}

##################################################
#######   Login|Storage VSI Variables    #########
##################################################
variable "login_node_instance_type" {
  type        = string
  default     = "bx2-2x8"
  description = "Specify the virtual server instance profile type name to be used to create the login (bastion) node for the Red Hat OpenShift cluster. For more information, see [Instance Profiles](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles)."
  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^[^\\s]+-[0-9]+x[0-9]+", var.login_node_instance_type))
    error_message = "The profile must be a valid profile name."
  }
}

variable "storage_node_instance_type" {
  type        = string
  default     = "bx2-2x8"
  description = "Specify the virtual server instance profile type to be used to create the NFS storage node for the Red Hat OpenShift cluster. The storage node is used to create an NFS file system instance that is exported and can be mounted for sharing data among the Red Hat OpenShift cluster nodes. For more information, see [Instance Profiles](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles)."
  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^[^\\s]+-[0-9]+x[0-9]+", var.storage_node_instance_type))
    error_message = "The profile must be a valid profile name."
  }
}

variable "mount_path" {
  type        = string
  default     = "data"
  description = "Specify the mount path name for the exported directory on the NFS storage node. For example, if the name provided is `data`, the exported directory will be `/data`."
}

variable "volume_profile" {
  type        = string
  default     = "general-purpose"
  description = "Name of the block storage volume type to be used for the NFS storage node. For more information, see [Block storage profiles](https://cloud.ibm.com/docs/vpc?topic=vpc-block-storage-profiles)."
}

variable "volume_iops" {
  type        = number
  default     = 300
  description = "Number to represent the IOPS (Input Output Per Second) configuration for block storage to be used for the NFS storage node (valid only for `volume_profile=custom`, dependent on `volume_capacity`. Enter a value in the range 100 - 48,000). For more information, see [Custom IOPS profile](https://cloud.ibm.com/docs/vpc?topic=vpc-block-storage-profiles&interface=ui#custom)."
  validation {
    condition     = 100 <= var.volume_iops && var.volume_iops <= 48000
    error_message = "Input \"volume_iops\" must be >= 100 and <= 48000."
  }
}

variable "volume_capacity" {
  type        = number
  default     = 100
  description = "Size in GB for the block storage that will be used to build the NFS file system instance on the storage node. Enter a value in the range 10 - 16,000. For more information, see [Block storage capacity and performance](https://cloud.ibm.com/docs/vpc?topic=vpc-capacity-performance&interface=ui#block-storage-vpc-capacity)."
  
  validation {
    condition     = 10 <= var.volume_capacity && var.volume_capacity <= 16000
    error_message = "Input \"volume_capacity\" must be >= 10 and <= 16000."
  }
}

# ##################################################
# ###########     Monitoring Variables     #########
# ##################################################

variable "enable_monitoring" {
  type        = bool
  default     = true
  description = " Specify whether you would like to set up a monitoring configuration for the Red Hat OpenShift cluster.  For more information, see [Monitoring cluster health](https://cloud.ibm.com/docs/openshift?topic=openshift-health-monitor)."
}

variable "enable_logdna" {
  type        = bool
  default     = true
  description = "Specify whether you would like to set up a logging configuration for the Red Hat OpenShift cluster.  For more information, see [Forwarding cluster and app logs to IBM Log Analysis](https://cloud.ibm.com/docs/openshift?topic=openshift-health#openshift_logging)."
}
