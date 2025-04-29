#!/bin/bash
NODES=("controller" "compute1" "compute2" "grafana")

echo "{" > dynamic_ips.tfvars.json
for i in "${!NODES[@]}"; do
  NODE="${NODES[$i]}"
  IP=$(multipass info "$NODE" | grep IPv4 | awk '{print $2}')
  if [ $i -eq $((${#NODES[@]} - 1)) ]; then
    echo "  \"$NODE\": \"$IP\"" >> dynamic_ips.tfvars.json
  else
    echo "  \"$NODE\": \"$IP\"," >> dynamic_ips.tfvars.json
  fi
done
echo "}" >> dynamic_ips.tfvars.json
