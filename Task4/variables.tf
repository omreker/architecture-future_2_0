variable "yc_cloud_id" {
  type        = string
  description = "ID облака"
}

variable "yc_folder_id" {
  type        = string
  description = "ID каталога"
}

variable "yc_zone" {
  type        = string
  description = "Зона доступности"
  default     = "ru-central1-a"
}

variable "image_id" {
  type        = string
  description = "ID образа Ubuntu"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Путь до публичного SSH-ключа"
  default     = "~/.ssh/id_rsa.pub"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

# Portal
variable "portal_cores" {
  type    = number
  default = 4
}

variable "portal_memory" {
  type    = number
  default = 8
}

variable "portal_disk_size" {
  type    = number
  default = 15
}

# Clinic
variable "clinic_cores" {
  type    = number
  default = 4
}

variable "clinic_memory" {
  type    = number
  default = 8
}

variable "clinic_disk_size" {
  type    = number
  default = 15
}

# Fintech
variable "fintech_cores" {
  type    = number
  default = 4
}

variable "fintech_memory" {
  type    = number
  default = 8
}

variable "fintech_disk_size" {
  type    = number
  default = 15
}

# AI
variable "ai_cores" {
  type    = number
  default = 8
}

variable "ai_memory" {
  type    = number
  default = 16
}

variable "ai_disk_size" {
  type    = number
  default = 20
}

variable "bucket_name" {
  type        = string
  description = "Имя бакета Object Storage"
}