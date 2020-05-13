variable "name" {
  default = "ubuntu-docker"
}

variable "image_name" {}

variable "flavor_name" {}

variable "keypair_name" {}

variable "security_groups" {
  type = list(string)
}

variable "network_name" {}

variable "pool_name" {}

variable "private_key_path" {
  default = "~/.ssh/id_rsa"
}

variable "docker_version" {
  default = "19.03"
}