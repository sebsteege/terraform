data "cloudinit_config" "apache" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "install_apache.sh"
    content_type = "text/x-shellscript"

    content = file("${path.module}/install_apache.sh")
  }

  part {
    filename     = "ubuntu_cloud_init.yml"
    content_type = "text/cloud-config"

    content = file("${path.module}/ubuntu_cloud_init.yml")
  }
}