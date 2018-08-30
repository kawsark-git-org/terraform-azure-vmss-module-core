variable "id_rsa_pub" {
  description = "contents of id_rsa.pub file for SSH access"
}

variable "core_resource_group_name" {
  description = "Name for core resource group"
  default = "azure-vmss-core"
}

variable "location" {
  description = "The location where resources are created"
  default     = "East US"
}

#Azure provider configured via Environment variables
provider "azurerm" {}

#Instantiate core module:
module "core" {
  source = "app.terraform.io/kawsark-git-org/terraform-azure-vmss-module-core"
  location = "${var.location}"
  core_resource_group_name = "${var.core_resource_group_name}"
  tags = {
    environment = "dev"
    owner       = "kawsar-at-hashicorp"
    ttl         = "24h"
    app         = "vmss-core"
    client      = "multiple"
  }
  id_rsa_pub = "${var.id_rsa_pub}"
}


output "jumpbox_public_ip" {
    value = "${module.core.jumpbox_public_ip}"
}

#Declare output so it can be accessed from terraform_remote_state data source
output "app_subnet_id" {
    value = "${module.core.app_subnet_id}"
}

