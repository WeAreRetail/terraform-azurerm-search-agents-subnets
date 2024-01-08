output "ids" {
  value       = local.agents_subnets_id_local
  description = "The IDs of the subnets in the current region."
}

output "ids_sql" {
  value       = local.agents_subnets_id_local
  description = "The IDs of the subnets for SQL."
}

output "ids_storage" {
  value       = local.agents_subnets_id_global
  description = "The IDs of the subnets for Storage."
}
