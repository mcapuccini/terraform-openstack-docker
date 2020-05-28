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

resource "null_resource" "install_docker" {
  triggers = {
    trigger = openstack_compute_floatingip_associate_v2.associate.id
  }

  provisioner "remote-exec" {
    connection {
      host        = openstack_networking_floatingip_v2.floating_ip.address
      user        = var.remote_user
      private_key = file(var.private_key_path)
    }

    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "curl releases.rancher.com/install-docker/${var.docker_version}.sh | bash",
      "sudo usermod -a -G docker ${var.remote_user}"
    ]

  }

}

resource "openstack_blockstorage_volume_v2" "new" {
  count = var.new_volume_size != null && var.volume_id == null ? 1 : 0
  name  = "${var.name}-volume"
  size  = var.new_volume_size
}

resource "openstack_compute_volume_attach_v2" "attach" {
  count       = var.volume_id != null || var.new_volume_size != null ? 1 : 0
  instance_id = openstack_compute_instance_v2.instance.id
  volume_id   = var.volume_id != null ? var.volume_id : element(openstack_blockstorage_volume_v2.new.*.id, 0)
  device      = var.volume_device
}

resource "null_resource" "new_volume" {
  triggers = {
    ip     = openstack_compute_floatingip_associate_v2.associate.id,
    attach = md5(join(",", openstack_compute_volume_attach_v2.attach.*.id))
  }

  provisioner "remote-exec" {
    connection {
      host        = openstack_networking_floatingip_v2.floating_ip.address
      user        = var.remote_user
      private_key = file(var.private_key_path)
    }

    inline = [
      "sudo mkdir /media/disk",
      var.volume_id == null || var.format_volume ? "sudo mkfs.ext4 ${var.volume_device}" : "true",
      "sudo mount ${var.volume_device} /media/disk"
    ]

  }

}