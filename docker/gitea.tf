resource "docker_image" "gitea" {
  name = "docker.gitea.com/gitea:latest"
}

resource "docker_container" "gitea" {
  name  = "gitea"
  image = docker_image.gitea.image_id
  restart = "always"
  ports {
    internal = 22
  }
  ports {
    internal = 3000
  }
  env = [
    "USER_UID=1000",
    "USER_GID=1000"
  ]
  volumes {
    host_path      = "${var.gitea_volume}"
    container_path = "/data"
    }
  volumes {
    host_path      = "/etc/timezone"
    container_path = "/etc/timezone"
    }
  volumes {
    host_path      = "/etc/localtime"
    container_path = "/etc/localtime"
    }
  networks_advanced {
    name = "services_network"
    }
}
