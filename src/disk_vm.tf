# Три одинаковых диска по 1 ГБ

resource "yandex_compute_disk" "vm_disk" {
  count = 3
  name  = "disk-${count.index+1}"
  size  = 1
  zone  = var.default_zone
}

# Одиночная ВМ storage

resource "yandex_compute_instance" "storage" {
  name        = var.storage_vm.vm_name
  hostname    = var.storage_vm.vm_name
  platform_id = var.storage_vm.platform_id
  zone        = var.default_zone
  allow_stopping_for_update = true

  resources {
    cores         = var.storage_vm.cores
    memory        = var.storage_vm.memory
    core_fraction = var.storage_vm.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.storage_vm.disk_volume
    }
  }

  scheduling_policy {
    preemptible = var.storage_vm.preemptible
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.vm_disk[*].id

    content {
      disk_id = secondary_disk.value
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.storage_vm.nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }
}