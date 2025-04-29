terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "grafana" {
  url      = "http://${var.grafana}:3000"
  auth     = "admin:admin"
  insecure_skip_verify = true
}
