resource "digitalocean_ssh_key" "default" {
  name       = "terraform"
  public_key = file("ssh_keys/id_rsa.pub")
}

resource "digitalocean_droplet" "default" {
  count     = var.amount
  image     = "fedora-34-x64"
  name      = "terraform-${count.index}"
  region    = "ams3"
  size      = "s-1vcpu-1gb"
  ssh_keys  = [digitalocean_ssh_key.default.fingerprint]
  user_data = file("cloud-init.yml")

  connection {
    host     = self.ipv4_address
    user     = "username"
    password = "password"
    timeout  = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo /usr/bin/cloud-init status --wait"
    ]
  }
}
