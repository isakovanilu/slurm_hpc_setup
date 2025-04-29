#!/bin/bash
set -e
sudo apt-get update
sudo apt-get install -y apt-transport-https software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana prometheus node-exporter
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl enable node-exporter
sudo systemctl start node-exporter
