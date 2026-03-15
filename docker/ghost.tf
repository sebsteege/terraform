resource "docker_image" "ghost_blog" {
  name = "ghost:latest"
}

resource "docker_image" "ghost_mysql" {
  name = "mysql:9"
}

resource "docker_container" "ghost_blog" {
  name  = "ghost"
  image = docker_image.ghost_blog.image_id
  depends_on = [docker_container.ghost_mysql]
  ports {
    internal = 2368
  }
  env = [
    "url=${var.ghost_url}",
    "mail__transport=SMTP",
    "mail__options__host=smtp.mailgun.org",
    "mail__options__port=587",
    "mail__options__auth__user=${var.mailgun_user}",
    "mail__options__auth__pass=${var.mailgun_password}",
    "database__client=mysql",
    "database__connection__host=ghost-db",
    "database__connection__user=ghost",
    "database__connection__password=${var.db_password}",
    "database__connection__database=ghost"
  ]
  volumes {
    host_path      = "${var.ghost_volume}"
    container_path = "/var/lib/ghost/content"
    }
  restart = "unless-stopped"
  networks_advanced {
    name = "blog_network"
    }
}

resource "docker_container" "ghost_mysql" {
  name  = "ghost-db"
  image = docker_image.ghost_mysql.image_id
  restart = "always"
  volumes {
    host_path      = "${var.ghostdb_volume}"
    container_path = "/var/lib/mysql"
    }
  env = [
    "MYSQL_ROOT_PASSWORD=${var.db_password}",
    "MYSQL_PASSWORD=${var.db_password}",
    "MYSQL_DATABASE=ghost",
    "MYSQL_USER=ghost",
    "MYSQL_ROOT_HOST=172.*.*.*"
  ]
  networks_advanced {
    name = "blog_network"
    }
}