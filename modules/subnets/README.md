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
| [ibm_is_subnet.subnet](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ip_count"></a> [ip\_count](#input\_ip\_count) | Enter total number of IP Address for each subnet | `any` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for all the resources. | `string` | n/a | yes |
| <a name="input_public_gateway_ids"></a> [public\_gateway\_ids](#input\_public\_gateway\_ids) | List of ids of all the public gateways where subnets will get attached | `list(any)` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Resource Group Name is used to seperated the resources in a group. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Add tag names to the cluster resources | `list` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Required parameter vpc\_id | `any` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | List of Availability Zones where compute resource will be created | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | Subnet ids of all zones |
