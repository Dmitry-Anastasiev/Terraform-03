resource "yandex_compute_instance" "web" {
  depends_on = [yandex_compute_instance.db]

  count       = local.count_vm_web
  name        = "${local.prefix_name_vm_web}-${count.index+1}"
  hostname    = "${local.prefix_name_vm_web}-${count.index+1}"
  platform_id = var.vms_resources.web.platform_id
  zone        = var.default_zone

  resources {
    cores         = var.vms_resources.web.cores
    memory        = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = var.vms_resources.web.preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vms_resources.web.nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  
  metadata = {
    ssh-keys = "ubuntu:${local.ssh_public_key}"
  }
}
