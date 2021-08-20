terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "~> 1.29.0"
    }
  }
}

##############################################################################
# Despliegue de recursos en DALLAS
##############################################################################

provider "ibm" {
  alias  = "south"
  region = "us-south"
}

data "ibm_resource_group" "group" {
  provider = ibm.south
  name = var.resource_group
}

##############################################################################
# Recuperar data de la SSH Key
##############################################################################

data "ibm_is_ssh_key" "sshkeydall" {
  provider = ibm.south
  name = var.ssh_keyname_dall
}

##############################################################################
# Recuperar data de la VPC DALLAS
##############################################################################

data "ibm_is_vpc" "dallas_vpc" {
  provider = ibm.south
  name = var.name_vpc_dallas
}

##############################################################################
# Recuperar data de la subnet en dallas
##############################################################################

data "ibm_is_subnet" "dallas_subnet" {
  provider = ibm.south
  name = var.name_subnet_dallas
}

##############################################################################
# Despliegue de servidores en dallas
##############################################################################

resource "ibm_is_instance" "cce-vsi-dal" {
  provider = ibm.south
  count    = var.count-vsi/2
  name    = "cce-vsidal-${count.index + 1}"
  image   = "r006-de4fc543-2ce1-47de-b0b8-b98556a741da"
  profile = "cx2-2x4"

  primary_network_interface {
    subnet = data.ibm_is_subnet.dallas_subnet.id
  }

  vpc       = data.ibm_is_vpc.dallas_vpc.id
  zone      = "us-south-1"
  keys      = [data.ibm_is_ssh_key.sshkeydall.id]
  resource_group = data.ibm_resource_group.group.id
}

##############################################################################
# Despliegue de recursos en WDC
##############################################################################

provider "ibm" {
  alias  = "east"
  region = "us-east"
}

##############################################################################
# Recuperar data de la SSH Key
##############################################################################

data "ibm_is_ssh_key" "sshkeywdc" {
  provider = ibm.east
  name = var.ssh_keyname_wdc
}

##############################################################################
# Recuperar data de la VPC WDC
##############################################################################

data "ibm_is_vpc" "wdc_vpc" {
  provider = ibm.east
  name = var.name_vpc_wdc
}

##############################################################################
# Recuperar data de la subnet en wdc
##############################################################################

data "ibm_is_subnet" "wdc_subnet" {
  provider = ibm.east
  name = var.name_subnet_wdc
}

##############################################################################
# Despliegue de servidores en wdc
##############################################################################

resource "ibm_is_instance" "cce-vsi-wdc" {
  provider = ibm.east
  count    = var.count-vsi/2
  name    = "cce-vsiwdc-${count.index + 1}"
  image   = "r006-de4fc543-2ce1-47de-b0b8-b98556a741da"
  profile = "cx2-2x4"

  primary_network_interface {
    subnet = data.ibm_is_subnet.wdc_subnet.id
  }

  vpc       = data.ibm_is_vpc.wdc_vpc.id
  zone      = "us-east-1"
  keys      = [data.ibm_is_ssh_key.sshkeywdc.id]
  resource_group = data.ibm_resource_group.group.id
}