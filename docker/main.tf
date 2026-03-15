terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "=3.6.2"
    }
  }
}

provider "docker" {
    host = "ssh://${var.docker_admin}@${var.docker_host}:22"
}