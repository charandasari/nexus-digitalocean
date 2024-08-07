
resource "digitalocean_ssh_key" "nexus_key_c" {
  name       = "example-key"
  public_key = file(var.public_key_path)
}

resource "digitalocean_firewall" "nexus_firewall_sonatype" {
  name = "nexus-firewall"

  droplet_ids = [digitalocean_droplet.nexus.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "8081"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "all"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  tags = ["nexus"]
}



resource "digitalocean_droplet" "nexus" {
  name   = "nexus-server"
  image  = "ubuntu-22-04-x64"  # Choose the Ubuntu version you prefer
  size   = "s-4vcpu-8gb"       # Choose the Droplet size
  region = "nyc1"              # Choose the region

  tags = ["nexus"]
  ssh_keys = [digitalocean_ssh_key.nexus_key_c.fingerprint]

  }


resource "null_resource" "provision_nexus" {
  provisioner "file" {
    source      = "provision.sh"
    destination = "/tmp/provision.sh"
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.private_key_path)
      host        = digitalocean_droplet.nexus.ipv4_address
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/provision.sh",
      "/tmp/provision.sh"
    ]
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.private_key_path)
      host        = digitalocean_droplet.nexus.ipv4_address
    }
  }

  depends_on = [digitalocean_droplet.nexus]
}


