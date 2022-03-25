resource "digitalocean_ssh_key" "default" {
  name       = "terraform"
  public_key = file("ssh_keys/id_rsa.pub")
}

resource "digitalocean_droplet" "default" {
  count     = var.amount
  image     = "fedora-35-x64"
  name      = "terraform-${count.index}"
  region    = "ams3"
  size      = "1gb"
  ssh_keys  = [digitalocean_ssh_key.default.fingerprint]
  user_data = file("cloud-init.yml")
  tags      = []
}

data "cloudflare_zones" "default" {
  filter {
    name = "robertdebock.nl"
  }
}

resource "cloudflare_record" "default" {
  count   = var.amount
  zone_id = data.cloudflare_zones.default.zones[0].id
  name    = "lab-${count.index}"
  value   = digitalocean_droplet.default[count.index].ipv4_address
  type    = "A"
  ttl     = 1
  proxied = false
}

