###cloud vars
# variable "token" {
#   type        = string
#   description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
# }

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vms_metadata" {
  type = map(string)
}

data "yandex_compute_image" "ubuntu" {
  family = var.vms_resources.web.family
}

variable "vms_resources" {
  type = map(object({
    family        = string
    platform_id   = string
    cores         = number
    memory        = number
    core_fraction = number
    preemptible   = bool
    nat           = bool
  }))
  default = {
    web={
      family        = "ubuntu-2004-lts"
      platform_id   = "standard-v1"
      cores         = 2
      memory        = 2
      core_fraction = 5
      preemptible   = true
      nat           = true
    }
  }
}

variable "each_vm" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    disk_volume   = number
    family        = string
    platform_id   = string
    core_fraction = number
    preemptible   = bool
    nat           = bool
  }))
  default = [
    {
      vm_name       = "main"
      cpu           = 4
      ram           = 4
      disk_volume   = 20
      family        = "ubuntu-2004-lts"
      platform_id   = "standard-v3"
      core_fraction = 50
      preemptible   = true
      nat           = true
    },
    {
      vm_name       = "replica"
      cpu           = 2
      ram           = 2
      disk_volume   = 10
      family        = "ubuntu-2004-lts"
      platform_id   = "standard-v3"
      core_fraction = 20
      preemptible   = true
      nat           = true
    }
  ]
}
