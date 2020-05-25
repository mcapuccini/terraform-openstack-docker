# Terraform OpenStack Docker
A simple Terraform module to start an Ubuntu instance with Docker on OpenStack.

## Examples

### Simple instance

```hcl
# Create instance
module "instance" {
  source          = "github.com/mcapuccini/terraform-openstack-docker"
  name            = "" # instance name
  image_name      = "" # image name (should be Ubuntu or similar)
  flavor_name     = "" # instance flavor name
  keypair_name    = "" # your keypair name
  security_groups = [] # list of security groups
  network_name    = "" # network to attach to
  pool_name       = "" # floating IP pool name    
}

# Output instance floating IP address
output "floating_ip" {
  value = module.instance.floating_ip
}
```

### Instance with a new volume

```hcl
module "instance" {
  source          = "github.com/mcapuccini/terraform-openstack-docker"
  name            = "" # instance name
  image_name      = "" # image name (should be Ubuntu or similar)
  flavor_name     = "" # instance flavor name
  keypair_name    = "" # your keypair name
  security_groups = [] # list of security groups
  network_name    = "" # network to attach to
  pool_name       = "" # floating IP pool name
  new_volume_size = "" # size of the new volume in GB    
}

# Output instance floating IP address
output floating_ip {
  value = module.instance.floating_ip
}
```
