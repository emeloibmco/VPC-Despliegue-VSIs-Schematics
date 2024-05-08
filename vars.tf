variable "region-pr" {
  default = "jp-osa"
  description = "ssh key name primary region"
}

variable "region-sec" {
  default = "jp-tok"
  description = "ssh key name secondary region"
}

variable "ssh_keyname_pr" {
  description = "ssh key name of primary region"
}

variable "ssh_keyname_sec" {
  description = "ssh key name sec"
}

variable "name_vpc_pr" {
  description = "vpc name primary region"
}
variable "image_vsi_pr" {
  description = "vsi image primary region"
}
variable "name_vpc_sec" {
  description = "vpc name secondary region"
}
variable "name_subnet_pr" {
  description = "subnet name primary region"
}
variable "subnet_zone_pr" {
  default = "1"
  description = "number that identify the zone"
}
variable "name_subnet_sec" {
  description = "subnet name secondary region"
}
variable "image_vsi_pr" {
  description = "vsi image primary region"
}
variable "subnet_zone_sec" {
  default = "1"
  description = "number that identify the zone"
}
variable "count-vsi" {
  description = "number of vsi"
}
variable "image_vsi_sec" {
  description = "vsi image secondary region"
}
variable "resource_group" {
  description = "resource group name"
}
