terraform {
  required_version = ">= 1.5.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

provider "yandex" {
service_account_key_file = "${path.module}/authorized_key.json"
  cloud_id                 = var.yc_cloud_id
  folder_id                = var.yc_folder_id
  zone                     = var.yc_zone
}


# Networking


resource "yandex_vpc_network" "main" {
  name = "future-2-0-network"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.public_subnet_cidr]
}

resource "yandex_vpc_subnet" "private" {
  name           = "private-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.private_subnet_cidr]
  route_table_id = yandex_vpc_route_table.nat.id
}

resource "yandex_vpc_gateway" "nat" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "nat" {
  name       = "nat-route-table"
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat.id
  }
}


# Security Groups


resource "yandex_vpc_security_group" "web" {
  name       = "web-sg"
  network_id = yandex_vpc_network.main.id

  ingress {
    description    = "HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTP (redirect)"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "internal" {
  name       = "internal-sg"
  network_id = yandex_vpc_network.main.id

  ingress {
    protocol          = "ANY"
    predefined_target = "self_security_group"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}


# Compute - Portal


resource "yandex_compute_instance" "portal" {
  name        = "self-service-portal"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores  = var.portal_cores
    memory = var.portal_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.portal_disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.web.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}


# Compute - Clinic


resource "yandex_compute_instance" "clinic" {
  name        = "clinic-domain"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores  = var.clinic_cores
    memory = var.clinic_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.clinic_disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.internal.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}


# Compute - Fintech


resource "yandex_compute_instance" "fintech" {
  name        = "fintech-domain"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores  = var.fintech_cores
    memory = var.fintech_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.fintech_disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.internal.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}


# Compute - AI


resource "yandex_compute_instance" "ai" {
  name        = "ai-domain"
  platform_id = "standard-v3"
  zone        = var.yc_zone

  resources {
    cores  = var.ai_cores
    memory = var.ai_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.ai_disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.internal.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}


# Object Storage


resource "yandex_storage_bucket" "data" {
  bucket = var.bucket_name
}