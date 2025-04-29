resource "grafana_dashboard" "node_metrics" {
  config_json = file("${path.module}/node_metrics_dashboard.json")
}

resource "grafana_dashboard" "slurm_metrics" {
  config_json = file("${path.module}/slurm_dashboard.json")
}
