provider "null" {}

variable "node_ips" {
  type    = list(string)
  default = ["192.168.64.2", "192.168.64.3"]
}

variable "private_key_path" {
  type    = string
  default = "~/.ssh/id_rsa"
}

resource "null_resource" "slurm_nodes" {
  count = length(var.node_ips)

  connection {
    type        = "ssh"
    host        = var.node_ips[count.index]
    user        = "ubuntu"
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "echo Connected to ${var.node_ips[count.index]}"
    ]
  }

  provisioner "local-exec" {
    command = "echo ${var.node_ips[count.index]} ansible_user=ubuntu >> ../ansible/inventory.ini"
  }
}

output "generated_inventory" {
  value = var.node_ips
}