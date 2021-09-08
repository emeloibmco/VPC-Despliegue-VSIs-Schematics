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

variable "name_vpc_sec" {
  description = "vpc name secondary region"
}

variable "name_subnet_pr" {
  description = "subnet name primary region"
}

variable "name_subnet_sec" {
  description = "subnet name secondary region"
}

variable "count-vsi" {
  description = "number of vsi"
}

variable "resource_group" {
  description = "resource group name"
}
