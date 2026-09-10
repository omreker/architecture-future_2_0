output "network_id" {
  value       = yandex_vpc_network.main.id
  description = "ID VPC"
}

output "public_subnet_id" {
  value = yandex_vpc_subnet.public.id
}

output "private_subnet_id" {
  value = yandex_vpc_subnet.private.id
}

output "portal_public_ip" {
  value       = yandex_compute_instance.portal.network_interface[0].nat_ip_address
  description = "Публичный IP Self-Service Portal"
}

output "clinic_private_ip" {
  value = yandex_compute_instance.clinic.network_interface[0].ip_address
}

output "fintech_private_ip" {
  value = yandex_compute_instance.fintech.network_interface[0].ip_address
}

output "ai_private_ip" {
  value = yandex_compute_instance.ai.network_interface[0].ip_address
}

output "bucket_name" {
  value = yandex_storage_bucket.data.bucket
}