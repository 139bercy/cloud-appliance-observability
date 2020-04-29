output "metrics-back-port" {
  value       = module.metrics_appliance.metrics-back-port
  description = "Metrics Appliance back-office port"
}

output "logs-back-port" {
  value       = module.logs_appliance.logs-back-port
  description = "Logs Appliance back-office port"
}

