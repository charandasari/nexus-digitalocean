terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.40.0"
    }
  }
}


provider "digitalocean" {
  token = var.digitalocean_token
}