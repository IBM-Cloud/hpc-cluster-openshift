# hpc-cluster-openshift

Red Hat® OpenShift® for HPC enables you to deploy Red Hat OpenShift clusters on IBM Cloud® infrastructure for running HPC workloads. The deployment is performed by using Terraform and IBM Cloud Schematics as automation frameworks.

# Deployment with Schematics UI on IBM Cloud

1. Go to <https://cloud.ibm.com/schematics/workspaces> and create a workspace using Schematics
2. After creating the Schematics workspace, at the bottom of the page enters this github repo URL and provide the Github token to access Github repo, and also select Terraform version as 1.0 and click Save.
3. Go to Schematic Workspace Settings, under variable section, click on "burger icons" to update the following mandatory parametes:
    - api_key : With the api key value and mark it as sensitive to hide the API key in the IBM Cloud Console.
    - Region : Enter region name in the IBM Cloud.
    - Resource_Group: Enter resource group name from your IBM Cloud account where the VPC resources should be deployed.
    - Update cluster_prefix value to the specific hostPrefix for your OpenShift cluster
    - ssh_key_name with your ibm cloud SSH key name such as "openshift-ssh-key" created in a specific region in IBM Cloud.
   
4. Click on "Generate Plan" and ensure there are no errors and fix the errors if there are any.
5. After "Generate Plan" gives no errors, click on "Apply Plan" to create resources.
6. Check the "Jobs" section on the left hand side to view the resource creation progress.
7. See the Logs if, "Apply Plan" activity is successful and copy the entire output section to your laptop for further operations.
8. Once cluster creation got completed then, validate your cluster by login to cloud.ibm.com -> OpenShift -> clusters.
9. To connect to the Login node, copy the output of Login_SSH_command from Schematics output section and run it on your local terminal.
10. To connect to the NFS server, copy the output of NFS_SSH_command from Schematics output section and run it on your local terminal.

# Deployment with Schematics CLI on IBM Cloud

Initial configuration:

```
$ cp sample/configs/hpc_workspace_config.json config.json
$ ibmcloud iam api-key-create my-api-key --file ~/.ibm-api-key.json -d "my api key"
$ cat ~/.ibm-api-key.json | jq -r ."apikey"
# copy your apikey
$ vim config.json
# paste your apikey and set entitlements for OpenShift
```

You also need to generate github token if you use private Github repository.

Deployment:

```
## Create a WorkSpace for OpenShift cluster creation.
$ ibmcloud schematics workspace new -f config.json --github-token xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

## List out available workspaces.
$ ibmcloud schematics workspace list
Name                            ID                                        Description   Status     Frozen
hpcc-openshift       us-east.workspace.hpcc-openshift.7eb468c6                          INACTIVE   False

OK

## Generate plan with Schematics plan.
$ ibmcloud schematics plan --id us-east.workspace.hpcc-openshift.7eb468c6

Activity ID b0a909030f071f51d6ceb48b62ee1671

OK

## Create a OpenShift cluster with Schematics apply.
$ ibmcloud schematics apply --id us-east.workspace.hpcc-openshift.7eb468c6
Do you really want to perform this action? [y/N]> y

Activity ID b0a909030f071f51d6ceb48b62ee1671

OK

## Get the logs of workspace.
$ ibmcloud schematics logs --id us-east.workspace.hpcc-openshift.7eb468c6
...
 2022/03/11 14:32:12 Terraform apply | Apply complete! Resources: 29 added, 0 changed, 0 destroyed.
 2022/03/11 14:32:12 Terraform apply | 
 2022/03/11 14:32:12 Terraform apply | Outputs:
 2022/03/11 14:32:12 Terraform apply | 
 2022/03/11 14:32:12 Terraform apply | logdna_url = [
 2022/03/11 14:32:12 Terraform apply |   "https://app.us-east.logging.cloud.ibm.com/ext/ibm-sso/d5fbc9d5a2",
 2022/03/11 14:32:12 Terraform apply | ]
 2022/03/11 14:32:12 Terraform apply | login_ssh_command = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@169.63.100.221"
 2022/03/11 14:32:12 Terraform apply | monitoring_url = [
 2022/03/11 14:32:12 Terraform apply |   "https://us-east.monitoring.cloud.ibm.com/api/oauth/openid/IBM/19066a3fe4ca466a810f7278fc902dc9/ae9d13f0-aac6-4fe8-8369-a4b42d2ca9e3",
 2022/03/11 14:32:12 Terraform apply | ]
 2022/03/11 14:32:12 Terraform apply | nfs_ssh_command = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -J root@169.63.100.221 root@10.241.4.12"
 2022/03/11 14:32:12 Terraform apply | openshift_url = "https://console-openshift-console.hpcc-openshift-us-east-cluster-e4a81a03080cf1544c1523261bec3d79-0000.us-east.containers.appdomain.cloud/dashboards"
 2022/03/11 14:32:12 Command finished successfully.
 2022/03/11 14:32:18 [1m[32mDone with the workspace action[39m[0m

OK

## Destroy your cluster.
$ ibmcloud schematics destroy --id us-east.workspace.hpcc-openshift.7eb468c6

## Destroy your workspace.
$ ibmcloud schematics workspace delete --id us-east.workspace.hpcc-openshift.7eb468c6

```

## Storage Node and NFS Setup
The storage node is configured as an NFS server and the data volume is mounted to the /data directory which is exported to share with OpenShift cluster worker nodes.
Note: If you given your own mount path name then NFS shared path will be available on same.

## Steps to validate NFS server
### To validate the NFS storage is setup and exported correctly
* Login to the storage node using SSH (ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -J root@169.63.100.221 root@10.241.4.12)(Get the SSH login command from Schematics Output)
* The below command shows that the data volume, either /dev/vde or /dev/vdd, is mounted to /data on the storage node.
```
# df -k | grep data
/dev/vde       104806400  763756 104042644   1% /data
```
* The command below shows that /data is exported as a NFS shared directory.

```
# exportfs -v
/data           10.248.0.0/16(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,no_root_squash,no_all_squash)
```

* At the NFS client end, the OpenShift worker nodes in this case, we mount the /data directory in NFS server to the local directory, /data.
```
# df -k | grep data
/dev/vde       104806400  763756 104042644   1% /data
```
The command above shows that the local directory, /data, is mounted to the remote /data directory on the NFS server, 10.241.4.12.

## Steps to validate the OpenShift cluster status from your Local terminal.

* Connect to IBM cloud account with your API key.
```
ibmcloud login --apikey <Your API key> -r <region-name>
```
* Install IBM Cloud container-service plugin.
```
ibmcloud plugin install container-service
```
* Validate the OpenShift cluster from ibmcloud cli and verify the the status of your cluster.
```
ibmcloud oc cluster ls | grep "your-prefix-name"
```

* SSH into Login server node (Get the SSH login command from Schematics Output)
```
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@169.63.100.221
```
#### Option-1 : Login with Config File
* Install IBM Cloud container-service plugin.
```
ibmcloud plugin install container-service
```
* Connect to IBM cloud account with your API key.
```
ibmcloud login --apikey <Your API key> -r <region-name>
```
* Get your cluster ID 
```
ibmcloud oc cluster ls | grep "your-cluster-prefix-name" | awk {'print $2'}
```
* Copy the cluster ID in the above command and run below command to generate config file.
```
ibmcloud oc cluster config -c <your-cluster-ID> --admin
```

#### Option-2 : Log in with Token
* Visit OpenShift clusters page (https://cloud.ibm.com/kubernetes/clusters?platformType=openshift) and select your cluster.

* Click on OpenShift-web-console -> Click on IAM#(your-mail-ID in top right corner) and select Copy-Login-command -> Click on Disply-Token

* Finally copy "Login with this token" output and execute into Login server.
```
oc login --token=sha256~81NTZ5iEbzWtraVyBX7ZAX9qanowKHce_tIZe65KnSs --server=https://c108-e.eu-gb.containers.cloud.ibm.com:30637
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | 1.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_ibm"></a> [ibm](#provider\_ibm) | 1.31.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_login_server"></a> [login\_server](#module\_login\_server) | ./modules/login_server | n/a |
| <a name="module_openshift_logdna"></a> [openshift\_logdna](#module\_openshift\_logdna) | ./modules/openshift_logdna | n/a |
| <a name="module_openshift_monitoring"></a> [openshift\_monitoring](#module\_openshift\_monitoring) | ./modules/openshift_monitoring | n/a |
| <a name="module_public_gateway"></a> [public\_gateway](#module\_public\_gateway) | ./modules/public_gateway | n/a |
| <a name="module_storage_instance"></a> [storage\_instance](#module\_storage\_instance) | ./modules/storage_instance | n/a |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | ./modules/subnets | n/a |
| <a name="module_vpc_openshift_cluster"></a> [vpc\_openshift\_cluster](#module\_vpc\_openshift\_cluster) | ./modules/openshift | n/a |

## Resources

| Name | Type |
|------|------|
| [ibm_is_vpc.vpc](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.31.0/docs/resources/is_vpc) | resource |
| [ibm_resource_instance.cos_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.31.0/docs/resources/resource_instance) | resource |
| [ibm_is_image.stock_image](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.31.0/docs/data-sources/is_image) | data source |
| [ibm_is_ssh_key.ssh_key](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.31.0/docs/data-sources/is_ssh_key) | data source |
| [ibm_is_volume_profile.nfs](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.31.0/docs/data-sources/is_volume_profile) | data source |
| [ibm_resource_group.res_grp](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.31.0/docs/data-sources/resource_group) | data source |
| [template_file.login_user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.storage_user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | This is the API key for IBM Cloud account in which the Red Hat OpenShift cluster needs to be deployed.  For more information on how to create an API key, see [Managing user API keys](https://cloud.ibm.com/docs/account?topic=account-userapikey). | `string` | n/a | yes |
| <a name="input_cluster_prefix"></a> [cluster\_prefix](#input\_cluster\_prefix) | Prefix that is used to name the IBM Cloud resources that are provisioned to build the Red Hat OpenShift cluster.  You cannot create more than one instance of the Red Hat OpenShift cluster with the same name. Make sure that the name is unique. Enter a prefix name, for example, 'my-openshift'.  The length of the prefix should be fewer than 13 characters. | `string` | `"hpcc-oc"` | no |
| <a name="input_enable_logdna"></a> [enable\_logdna](#input\_enable\_logdna) | Specify whether you would like to set up a logging configuration for the Red Hat OpenShift cluster.  For more information, see [Forwarding cluster and app logs to IBM Log Analysis](https://cloud.ibm.com/docs/openshift?topic=openshift-health#openshift_logging). | `bool` | `true` | no |
| <a name="input_enable_monitoring"></a> [enable\_monitoring](#input\_enable\_monitoring) | Specify whether you would like to set up a monitoring configuration for the Red Hat OpenShift cluster.  For more information, see [Monitoring cluster health](https://cloud.ibm.com/docs/openshift?topic=openshift-health-monitor). | `bool` | `true` | no |
| <a name="input_kube_version"></a> [kube\_version](#input\_kube\_version) | The Red Hat OpenShift version that you want to set up in your cluster. Available versions:   4.9\_openshift and 4.8\_openshift.  For more information, see [Version information and update actions](https://cloud.ibm.com/docs/openshift?topic=openshift-openshift_versions). | `string` | `"4.9_openshift"` | no |
| <a name="input_login_node_instance_type"></a> [login\_node\_instance\_type](#input\_login\_node\_instance\_type) | Specify the virtual server instance profile type name to be used to create the login (bastion) node for the Red Hat OpenShift cluster. For more information, see [Instance Profiles](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles). | `string` | `"bx2-2x8"` | no |
| <a name="input_mount_path"></a> [mount\_path](#input\_mount\_path) | Specify the mount path name for the exported directory on the NFS storage node. For example, if the name provided is `data`, the exported directory will be `/data`. | `string` | `"data"` | no |
| <a name="input_region"></a> [region](#input\_region) | Enter a region from the following list in which the cluster will be deployed: us-south, us-east, eu-gb, eu-de, jp-tok, au-syd, jp-osa, br-sao, ca-tor. For more information, see [Region and data center locations for resource deployment](https://cloud.ibm.com/docs/overview?topic=overview-locations). | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Resource group name from your IBM Cloud account where the VPC resources should be deployed. For more information, see [Managing resource groups](https://cloud.ibm.com/docs/account?topic=account-rgs). | `string` | `"Default"` | no |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | Comma-separated list of names of the SSH key configured in your IBM Cloud account that is used to establish a connection to the Red Hat OpenShift login node. Ensure that the SSH key is present in the same resource group and region where the cluster is being provisioned. If you do not have an SSH key in your IBM Cloud account, create one by using the [SSH keys](https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys) instructions. | `string` | n/a | yes |
| <a name="input_storage_node_instance_type"></a> [storage\_node\_instance\_type](#input\_storage\_node\_instance\_type) | Specify the virtual server instance profile type to be used to create the NFS storage node for the Red Hat OpenShift cluster. The storage node is used to create an NFS file system instance that is exported and can be mounted for sharing data among the Red Hat OpenShift cluster nodes. For more information, see [Instance Profiles](https://cloud.ibm.com/docs/vpc?topic=vpc-profiles). | `string` | `"bx2-2x8"` | no |
| <a name="input_volume_capacity"></a> [volume\_capacity](#input\_volume\_capacity) | Size in GB for the block storage that will be used to build the NFS file system instance on the storage node. Enter a value in the range 10 - 16,000. For more information, see [Block storage capacity and performance](https://cloud.ibm.com/docs/vpc?topic=vpc-capacity-performance&interface=ui#block-storage-vpc-capacity). | `number` | `100` | no |
| <a name="input_volume_iops"></a> [volume\_iops](#input\_volume\_iops) | Number to represent the IOPS (Input Output Per Second) configuration for block storage to be used for the NFS storage node (valid only for `volume_profile=custom`, dependent on `volume_capacity`. Enter a value in the range 100 - 48,000). For more information, see [Custom IOPS profile](https://cloud.ibm.com/docs/vpc?topic=vpc-block-storage-profiles&interface=ui#custom). | `number` | `300` | no |
| <a name="input_volume_profile"></a> [volume\_profile](#input\_volume\_profile) | Name of the block storage volume type to be used for the NFS storage node. For more information, see [Block storage profiles](https://cloud.ibm.com/docs/vpc?topic=vpc-block-storage-profiles). | `string` | `"general-purpose"` | no |
| <a name="input_worker_nodes_per_zone"></a> [worker\_nodes\_per\_zone](#input\_worker\_nodes\_per\_zone) | The number of worker nodes per zone in the default worker pool. Minimum is one node, and 1,000 is the maximum for each zone. For more information, see [Planning your worker node setup](https://cloud.ibm.com/docs/openshift?topic=openshift-planning_worker_nodes). | `number` | `1` | no |
| <a name="input_worker_pool_flavor"></a> [worker\_pool\_flavor](#input\_worker\_pool\_flavor) | The flavor of the Red Hat OpenShift worker nodes that you want to create and attach to the cluster. For more information, see [Available flavors for VMs](https://cloud.ibm.com/docs/openshift?topic=openshift-planning_worker_nodes#vm-table). | `string` | `"bx2.4x16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_logdna_url"></a> [logdna\_url](#output\_logdna\_url) | LogDNA URL |
| <a name="output_login_ssh_command"></a> [login\_ssh\_command](#output\_login\_ssh\_command) | Login sever SSH comand |
| <a name="output_monitoring_url"></a> [monitoring\_url](#output\_monitoring\_url) | Monitoring URL |
| <a name="output_nfs_ssh_command"></a> [nfs\_ssh\_command](#output\_nfs\_ssh\_command) | Storage Server SSH command |
| <a name="output_openshift_url"></a> [openshift\_url](#output\_openshift\_url) | OpenShift URL |
