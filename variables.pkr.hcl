variable "architecture" {
  type        = string
  default     = "x86_64"
  description = "Architecture of your AMI: can be arm64, or x86_64"
}

variable "docker_port" {
  type        = number
  default     = 8081
  description = "Port for Docker container"
}

variable "manifest_file_name" {
  type        = string
  default     = "manifest.json"
  description = "Manifest file name"
}

locals {
  tags = {
    Name    = "packer-${var.architecture}"
    Hillel  = "Homework 15"
    Student = "Dmytro Gukov"
  }

  timestamp = formatdate("YYYYMMDDhhmm", timestamp())
}