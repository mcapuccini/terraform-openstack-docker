output "floating_ip" {
  value = openstack_networking_floatingip_v2.floating_ip.address
}

output "docker_host" {
  value = "ssh://${var.remote_user}@${openstack_networking_floatingip_v2.floating_ip.address}"
}