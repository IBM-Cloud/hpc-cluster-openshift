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
| [ibm_is_floating_ip.login_floating_ip](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_floating_ip) | resource |
| [ibm_is_instance.login](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_instance) | resource |
| [ibm_is_public_gateway.pg](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_public_gateway) | resource |
| [ibm_is_security_group.login_sg](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group) | resource |
| [ibm_is_security_group_rule.login_inbound](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule) | resource |
| [ibm_is_security_group_rule.login_outbound](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule) | resource |
| [ibm_is_subnet.login_sub](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_login_image"></a> [login\_image](#input\_login\_image) | Image ID of Login server | `string` | n/a | yes |
| <a name="input_login_profile"></a> [login\_profile](#input\_login\_profile) | Your Server Flavour for Login server | `string` | n/a | yes |
| <a name="input_login_ssh_key"></a> [login\_ssh\_key](#input\_login\_ssh\_key) | List of SSH key ID's | `list(any)` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix that is used to name the OpenShift cluster and IBM Cloud resources that are provisioned to build the OpenShift cluster instance. You cannot create more than one instance of the OpenShift cluster with the same name. Make sure that the name is unique. Enter a prefix name, such as my-openshift. Length of prefix should be less than 13 characters. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Enter a region from the following available region and zones mapping: <br>us-south<br>us-east<br>eu-gb<br>eu-de<br>jp-tok<br>au-syd<br>jp-osa<br>br-sao<br>ca-tor.Find the region details [here](https://cloud.ibm.com/docs/overview?topic=overview-locations). | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Resource Group Id is used to seperated the resources in a group. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Add Cluster resource tags to the OpenShift cluster resources | `list` | n/a | yes |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Userdata script for Login Server | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | This is the vpc id which will be used for Login Server module. We are passing this vpc\_id from main.tf | `any` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | List of Availability Zones where compute resource will be created | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_login_ip_addr"></a> [login\_ip\_addr](#output\_login\_ip\_addr) | SSH commend for Login Server |
| <a name="output_login_pg_id"></a> [login\_pg\_id](#output\_login\_pg\_id) | Public Gateway Id's |
| <a name="output_login_sg_id"></a> [login\_sg\_id](#output\_login\_sg\_id) | login \| Jumphost security group ID |
