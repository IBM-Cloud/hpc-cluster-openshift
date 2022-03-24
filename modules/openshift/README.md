## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_ibm"></a> [ibm](#provider\_ibm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [ibm_container_vpc_cluster.cluster](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/container_vpc_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster. | `string` | n/a | yes |
| <a name="input_cos_instance_crn"></a> [cos\_instance\_crn](#input\_cos\_instance\_crn) | Enable openshift entitlement during cluster creation. | `string` | n/a | yes |
| <a name="input_kube_version"></a> [kube\_version](#input\_kube\_version) | The Kubernetes or OpenShift version that you want to set up in your cluster. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Enter a region from the following available region and zones mapping: <br>us-south<br>us-east<br>eu-gb<br>eu-de<br>jp-tok<br>au-syd<br>jp-osa<br>br-sao<br>ca-tor.Find the region details [here](https://cloud.ibm.com/docs/overview?topic=overview-locations). | `string` | n/a | yes |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | ID of resource group. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Add tag names to the cluster resources. | `list` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | This is the vpc id which will be used for Login Server module. We are passing this vpc\_id from main.tf | `string` | n/a | yes |
| <a name="input_worker_nodes_per_zone"></a> [worker\_nodes\_per\_zone](#input\_worker\_nodes\_per\_zone) | The number of worker nodes per zone in the default worker pool. | `number` | n/a | yes |
| <a name="input_worker_pool_flavor"></a> [worker\_pool\_flavor](#input\_worker\_pool\_flavor) | The flavor of the OpenShift worker node that you want to use. | `string` | n/a | yes |
| <a name="input_worker_zone"></a> [worker\_zone](#input\_worker\_zone) | List of Availability Zones where compute resource will be created. | `list(any)` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | List of Availability Zones where compute resource will be created. | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ingress_subdomain"></a> [ingress\_subdomain](#output\_ingress\_subdomain) | n/a |
| <a name="output_public_service_endpoint_url"></a> [public\_service\_endpoint\_url](#output\_public\_service\_endpoint\_url) | n/a |
| <a name="output_url"></a> [url](#output\_url) | n/a |
