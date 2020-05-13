# Terraform OpenStack Docker
A simple Terraform module to start an Ubuntu instance with Docker on OpenStack.

## Examples

### Start an instance

```hcl
module "instance" {
  source  = "github.com/mcapuccini/terraform-openstack-docker"
  image_name      = "" # image name (should be Ubuntu or similar)
  flavor_name     = "" # instance flavor name
  keypair_name    = "" # your keypair name
  security_groups = [] # list of security groups
  network_name    = "" # network to attach to
  pool_name       = "" # floating IP pool name    
}
```