variable "digitalocean_token" {
  description = "The token for DigitalOcean API access"
  type        = string
  sensitive   = true
  default     = ""
}

variable "public_key_path" {
  description = "The path to your SSH public key"
  type        = string
}

variable "private_key_path" {
  description = "The path to your SSH private key"
  type        = string
}