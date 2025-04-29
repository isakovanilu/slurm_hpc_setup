#!/bin/bash

echo "Checking Controller Node (Slurmctld)..."
multipass exec controller -- systemctl is-active slurmctld

echo "Checking Compute Nodes (Slurmd)..."
multipass exec compute1 -- systemctl is-active slurmd
multipass exec compute2 -- systemctl is-active slurmd

echo "Checking Grafana Server..."
curl -s -o /dev/null -w "%{http_code}\n" http://$(multipass info grafana | grep IPv4 | awk '{print $2}'):3000

echo "Checking Prometheus Server..."
curl -s -o /dev/null -w "%{http_code}\n" http://$(multipass info grafana | grep IPv4 | awk '{print $2}'):9090

echo "Checking Node Exporter..."
curl -s -o /dev/null -w "%{http_code}\n" http://$(multipass info grafana | grep IPv4 | awk '{print $2}'):9100/metrics

echo "Checking SLURM Exporter..."
curl -s -o /dev/null -w "%{http_code}\n" http://$(multipass info controller | grep IPv4 | awk '{print $2}'):9816/metrics
