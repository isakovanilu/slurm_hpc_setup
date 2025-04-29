output "grafana_url" {
  value = "http://${var.grafana}:3000"
}

output "prometheus_url" {
  value = "http://${var.grafana}:9090"
}

output "node_exporter_url" {
  value = "http://${var.grafana}:9100/metrics"
}

output "slurm_exporter_url" {
  value = "http://${var.grafana}:9816/metrics"
}
