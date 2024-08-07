output "nexus_url" {
  description = "URL to access the Nexus Repository Manager"
  value       = "http://${digitalocean_droplet.nexus.ipv4_address}:8081"
}