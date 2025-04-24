provider "null" {}

variable "node_ips" {
  type    = map(string)
  default = {
    controller = "10.0.0.1"
    compute1   = "10.0.0.2"
    compute2   = "10.0.0.3"
    compute3   = "10.0.0.4"
  }
}

variable "private_key_path" {
  type    = string
  default = "/path/to/your/private/key"

}

resource "null_resource" "slurm_nodes" {
  for_each = var.node_ips

  connection {
    type        = "ssh"
    host        = each.value
    user        = "ubuntu"
    private_key = file(var.private_key_path)
  }

  # Install base packages and add hostnames
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y munge slurm-wlm",
      "echo '${var.node_ips.controller} controller' | sudo tee -a /etc/hosts",
      "echo '${var.node_ips.compute1} compute1' | sudo tee -a /etc/hosts",
      "echo '${var.node_ips.compute2} compute2' | sudo tee -a /etc/hosts",
      "echo '${var.node_ips.compute3} compute3' | sudo tee -a /etc/hosts"
    ]
  }

  # Transfer munge.key and slurm.conf
  provisioner "file" {
    source      = "munge.key"
    destination = "/home/ubuntu/munge.key"
  }

  provisioner "file" {
    source      = "slurm_updated.conf"
    destination = "/home/ubuntu/slurm.conf"
  }

  # Move and set permissions
  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/ubuntu/munge.key /etc/munge/munge.key",
      "sudo chown munge:munge /etc/munge/munge.key",
      "sudo chmod 400 /etc/munge/munge.key",
      "sudo mkdir -p /etc/slurm",
      "sudo mv /home/ubuntu/slurm.conf /etc/slurm/slurm.conf",
      "sudo chmod 644 /etc/slurm/slurm.conf",
      "sudo systemctl restart munge",
      "if [ \\\"${each.key}\\\" = \\\"controller\\\" ]; then sudo systemctl restart slurmctld; else sudo systemctl restart slurmd; fi"
    ]
  }
}

output "configured_nodes" {
  value = keys(var.node_ips)
}