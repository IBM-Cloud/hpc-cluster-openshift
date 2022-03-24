#!/bin/bash

###################################################
# Copyright (C) IBM Corp. 2021 All Rights Reserved.
# Licensed under the Apache License v2.0
###################################################

curl -L https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable-4.9/openshift-client-linux.tar.gz --output oc.tar.gz && tar -xvf oc.tar.gz && mv oc /usr/local/bin/oc && mv kubectl /usr/local/bin/kubectl
curl -sL https://raw.githubusercontent.com/IBM-Cloud/ibm-cloud-developer-tools/master/linux-installer/idt-installer | bash
ibmcloud plugin install container-service