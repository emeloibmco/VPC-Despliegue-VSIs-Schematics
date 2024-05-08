terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "~> 1.30.2"
    }
  }
}

##############################################################################
# Despliegue de recursos en el datacenter primario
##############################################################################

provider "ibm" {
  alias  = "primary"
  region = var.region-pr
  max_retries = 20
}

data "ibm_resource_group" "group" {
  provider = ibm.primary
  name = var.resource_group
}

##############################################################################
# Recuperar data de la SSH Key
##############################################################################

data "ibm_is_ssh_key" "sshkeypr" {
  provider = ibm.primary
  name = var.ssh_keyname_pr
}

##############################################################################
# Recuperar data de la VPC primary
##############################################################################

data "ibm_is_vpc" "pr_vpc" {
  provider = ibm.primary
  name = var.name_vpc_pr
}

##############################################################################
# Recuperar data de la subnet primary
##############################################################################

data "ibm_is_subnet" "pr_subnet" {
  provider = ibm.primary
  name = var.name_subnet_pr
}

##############################################################################
# Despliegue de recursos en en datacenter secundario
##############################################################################

provider "ibm" {
  alias  = "secondary"
  region = var.region-sec
  max_retries = 20
}

##############################################################################
# Recuperar data de la SSH Key
##############################################################################

data "ibm_is_ssh_key" "sshkeysec" {
  provider = ibm.secondary
  name = var.ssh_keyname_sec
}

##############################################################################
# Recuperar data de la VPC secondary
##############################################################################

data "ibm_is_vpc" "sec_vpc" {
  provider = ibm.secondary
  name = var.name_vpc_sec
}

##############################################################################
# Recuperar data de la subnet en sec
##############################################################################

data "ibm_is_subnet" "sec_subnet" {
  provider = ibm.secondary
  name = var.name_subnet_sec
}

##############################################################################
# Despliegue de servidores en el datacenter primario
##############################################################################

resource "ibm_is_instance" "cce-vsi-pr" {
  provider = ibm.primary
  count    = var.count-vsi/2
  name    = "cce-vsipr-${count.index + 1}"
  image   = "r006-13938c0a-89e4-4370-b59b-55cd1402562d"
  profile = "cx2-4x8"

  primary_network_interface {
    subnet = data.ibm_is_subnet.pr_subnet.id
  }

  vpc       = data.ibm_is_vpc.pr_vpc.id
  zone      = "${var.region-pr}-${var.subnet_zone_pr}"
  keys      = [data.ibm_is_ssh_key.sshkeypr.id]
  resource_group = data.ibm_resource_group.group.id
}

##############################################################################
# Despliegue de servidores en el datacenter secundario
##############################################################################

resource "ibm_is_instance" "cce-vsi-sec" {
  provider = ibm.secondary
  count    = var.count-vsi/2
  name    = "cce-vsisec${count.index + 1}"
  image   = "r006-13938c0a-89e4-4370-b59b-55cd1402562d"
  profile = "cx2-4x8"

  primary_network_interface {
    subnet = data.ibm_is_subnet.sec_subnet.id
  }

  vpc       = data.ibm_is_vpc.sec_vpc.id
  zone      = "${var.region-sec}-${var.subnet_zone_sec}"
  keys      = [data.ibm_is_ssh_key.sshkeysec.id]
  resource_group = data.ibm_resource_group.group.id
}
