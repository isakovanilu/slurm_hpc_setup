#!/bin/bash
set -e

# Install Golang if not already installed
sudo apt-get update -y
sudo apt-get install -y golang-go git make

# Clone and build slurm_exporter
cd /opt
sudo git clone https://github.com/vpenso/prometheus-slurm-exporter.git slurm_exporter
cd slurm_exporter
sudo make

# Create slurm_exporter systemd service
cat <<EOF | sudo tee /etc/systemd/system/slurm_exporter.service
[Unit]
Description=Prometheus SLURM Exporter
After=network.target

[Service]
Type=simple
ExecStart=/opt/slurm_exporter/slurm_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start and enable service
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable slurm_exporter
sudo systemctl start slurm_exporter
