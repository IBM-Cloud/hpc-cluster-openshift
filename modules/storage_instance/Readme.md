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
| [ibm_is_instance.storage_instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance) | resource |
| [ibm_is_security_group.sg](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group) | resource |
| [ibm_is_security_group_rule.nfs_inbound](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule) | resource |
| [ibm_is_security_group_rule.nfs_outbound](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule) | resource |
| [ibm_is_security_group_rule.ssh_inbound](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule) | resource |
| [ibm_is_subnet.nfs_sub](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_subnet) | resource |
| [ibm_is_volume.nfs](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_volume) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for all the resources. | `string` | n/a | yes |
| <a name="input_public_gateway_ids"></a> [public\_gateway\_ids](#input\_public\_gateway\_ids) | List of ids of all the public gateways where subnets will get attached | `list(any)` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Get your Region | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Resource Group Name is used to seperated the resources in a group. | `string` | n/a | yes |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | Allowing this security groups to connect NFS server. | `string` | n/a | yes |
| <a name="input_storage_image"></a> [storage\_image](#input\_storage\_image) | NFS Storage VSI Image | `string` | n/a | yes |
| <a name="input_storage_profile"></a> [storage\_profile](#input\_storage\_profile) | Your Server Flavour | `string` | n/a | yes |
| <a name="input_storage_ssh_key"></a> [storage\_ssh\_key](#input\_storage\_ssh\_key) | List of SSH key ID's | `list(any)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Add tag names to the cluster resources | `list` | n/a | yes |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Calling user\_data script | `string` | n/a | yes |
| <a name="input_volume_capacity"></a> [volume\_capacity](#input\_volume\_capacity) | Required NFS volume storage capacity in GB's | `number` | n/a | yes |
| <a name="input_volume_iops"></a> [volume\_iops](#input\_volume\_iops) | Number to represent the IOPS | `number` | n/a | yes |
| <a name="input_volume_profile"></a> [volume\_profile](#input\_volume\_profile) | Enter you Volume profile details. | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Required parameter vpc\_id | `any` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | List of Availability Zones where compute resource will be created | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nfs_private_ip"></a> [nfs\_private\_ip](#output\_nfs\_private\_ip) | SSH commend for Storage Server |
