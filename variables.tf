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

variable "new_volume_size" {
  default = null
}

variable "volume_id" {
  default = null
}

variable "volume_device" {
  default = "/dev/vdb"
}

variable "format_volume" {
  default = false
}