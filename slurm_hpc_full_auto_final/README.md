# SLURM HPC Cluster with Full Monitoring

This project fully automates the setup of a SLURM mini-HPC cluster using Multipass VMs, Terraform, Prometheus, and Grafana.

## 🖥 Architecture

- Controller Node (SLURM Controller, SLURM Exporter)
- Compute Nodes (1-2 Nodes)
- Grafana Node (Grafana + Prometheus + Node Exporter)
- Full Terraform Automation

## 🚀 Setup Instructions

```bash
bash fetch_ips.sh
terraform init
terraform apply -var-file=dynamic_ips.tfvars.json -auto-approve
```

Access Grafana:
- URL: http://<grafana-ip>:3000 (admin/admin)

Dashboards:
- Node Metrics Dashboard (CPU, Memory, Disk)
- SLURM Metrics Dashboard (Running Jobs, Node States)

## 🛠 Tear Down

```bash
terraform destroy -var-file=dynamic_ips.tfvars.json -auto-approve
```

Enjoy your full HPC monitoring system! 🎯
