resource "openstack_compute_instance_v2" "instance" {
  name            = var.name
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = var.keypair_name
  security_groups = var.security_groups

  network {
    name = var.network_name
  }
}

resource "openstack_networking_floatingip_v2" "floating_ip" {
  pool = var.pool_name
}

resource "openstack_compute_floatingip_associate_v2" "associate" {
  floating_ip = openstack_networking_floatingip_v2.floating_ip.address
  instance_id = openstack_compute_instance_v2.instance.id
}

resource "null_resource" "provisioner" {
  triggers = {
    trigger = openstack_compute_floatingip_associate_v2.associate.id
  }

  provisioner "remote-exec" {
    connection {
      host        = openstack_networking_floatingip_v2.floating_ip.address
      user        = "ubuntu"
      private_key = file(var.private_key_path)
    }

    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "curl releases.rancher.com/install-docker/${var.docker_version}.sh | bash",
      "sudo usermod -a -G docker ubuntu"
    ]

  }

}