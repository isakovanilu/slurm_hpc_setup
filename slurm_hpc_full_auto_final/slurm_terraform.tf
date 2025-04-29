variable "controller" { type = string }
variable "compute1" { type = string }
variable "compute2" { type = string }
variable "grafana"  { type = string }

resource "null_resource" "setup_controller" {
  connection {
    type        = "ssh"
    host        = var.controller
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
  }
  provisioner "remote-exec" {
    inline = ["echo Controller setup done!"]
  }
}
