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
| [ibm_ob_logging.logging](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/ob_logging) | resource |
| [ibm_resource_instance.logdna_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_instance) | resource |
| [ibm_resource_key.resourceKey](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/resource_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster"></a> [cluster](#input\_cluster) | Name of your OpenShift cluster | `string` | n/a | yes |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | Timeout duration for create. | `string` | `"45m"` | no |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | Timeout duration for delete. | `string` | `"10m"` | no |
| <a name="input_logdna_ingestion_key"></a> [logdna\_ingestion\_key](#input\_logdna\_ingestion\_key) | logdna\_ingestion\_key | `string` | `null` | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | Add this option to connect to your LogDNA service instance through the private service endpoint | `bool` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Name of the Region | `string` | n/a | yes |
| <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id) | ID of resource group. | `string` | n/a | yes |
| <a name="input_update_timeout"></a> [update\_timeout](#input\_update\_timeout) | Timeout duration for update. | `string` | `"10m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_logdna_url"></a> [logdna\_url](#output\_logdna\_url) | LogDNA URL for Openshift cluster |
