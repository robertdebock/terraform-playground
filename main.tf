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
