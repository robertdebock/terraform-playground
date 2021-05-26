output "droplet_ip_address" {
  value = digitalocean_droplet.default.*.ipv4_address
}
