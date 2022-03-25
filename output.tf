# output "ip_addresses" {
#   value = digitalocean_droplet.default.*.ipv4_address
# }

output "hostnames" {
  value = cloudflare_record.default.*.hostname
}
