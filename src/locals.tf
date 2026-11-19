locals {
  # Company
  company = "netology"
  # Prod, Test, Develop
  env = "develop"
  # Project
  project = "platform"

  # prefix web
  prefix_name_vm_web = "${local.company}-${local.env}-${local.project}-web"
  # count VM web
  count_vm_web = 2

  # prefix db
  prefix_name_vm_db = "${local.company}-${local.env}-${local.project}-db"
}

locals {
  ssh_public_key = file("~/.ssh/id_ed25519.pub")
}
