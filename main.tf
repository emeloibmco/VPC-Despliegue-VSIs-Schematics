terraform {
  required_providers {
    ibm = {
      source = "IBM-Cloud/ibm"
      version = "~> 1.12.0"
    }
  }
}

provider "ibm" {
  alias  = "south"
  region = "us-south"
}

data "ibm_resource_group" "group" {
  provider = ibm.south
  name = var.resource_group
}

resource "ibm_is_ssh_key" "cce-ssh-dal" {
  name       = "cce-ssh-dal"
  public_key = var.ssh-public-key-dal
  resource_group = data.ibm_resource_group.group.id
}

##############################################################################
# Create a VPC DALLAS
##############################################################################

resource "ibm_is_vpc" "vpc-dal" {
  provider = ibm.south
  name          = "cce-vpc-dal"
  resource_group = data.ibm_resource_group.group.id
}

##############################################################################
# Create Subnet zone DALL
##############################################################################

# Increase count to create subnets in all zones
resource "ibm_is_subnet" "cce-subnet-dal" {
  provider = ibm.south
  name            = "cce-subnet-dal"
  vpc             = ibm_is_vpc.vpc-dal.id
  zone            = "us-south-1"
  total_ipv4_address_count= "256"
  resource_group  = data.ibm_resource_group.group.id
}

##############################################################################
# Desploy instances on DALL
##############################################################################

resource "ibm_is_instance" "cce-vsi-dal" {
  provider = ibm.south
  count    = var.count-vsi/2
  name    = "cce-vsi-${count.index + 1}"
  image   = "r006-de4fc543-2ce1-47de-b0b8-b98556a741da"
  profile = "cx2-2x4"

  primary_network_interface {
    subnet = ibm_is_subnet.cce-subnet-dal.id
  }

  vpc       = ibm_is_vpc.vpc-dal.id
  zone      = "us-south-1"
  keys      = [ibm_is_ssh_key.cce-ssh-dal.id]
  resource_group = data.ibm_resource_group.group.id
}

provider "ibm" {
  alias  = "east"
  region = "us-east"
}

resource "ibm_is_ssh_key" "cce-ssh-wdc" {
  provider = ibm.east
  name       = "cce-ssh-wdc"
  public_key = var.ssh-public-key-wdc
  resource_group = data.ibm_resource_group.group.id
}

##############################################################################
# Create a VPC WDC
##############################################################################

resource "ibm_is_vpc" "vpc-wdc" {
  provider = ibm.east
  name          = "cce-vpc-wdc"
  resource_group = data.ibm_resource_group.group.id
}

##############################################################################
# Create Subnet zone WDC
##############################################################################

# Increase count to create subnets in all zones
resource "ibm_is_subnet" "cce-subnet-wdc" {
  provider = ibm.east
  name            = "cce-subnet-wdc"
  vpc             = ibm_is_vpc.vpc-wdc.id
  zone            = "us-east-1"
  total_ipv4_address_count= "256"
  resource_group  = data.ibm_resource_group.group.id
}

##############################################################################
# Desploy instances on WDC
##############################################################################

resource "ibm_is_instance" "cce-vsi-wdc" {
  provider = ibm.east
  count    = var.count-vsi/2
  name    = "cce-vsi-${count.index + 1}"
  image   = "r014-ce5f692d-763d-4b5a-bca2-93d6990fb3fd"
  profile = "cx2-2x4"

  primary_network_interface {
    subnet = ibm_is_subnet.cce-subnet-wdc.id
  }

  vpc       = ibm_is_vpc.vpc-wdc.id
  zone      = "us-east-1"
  keys      = [ibm_is_ssh_key.cce-ssh-wdc.id]
  resource_group = data.ibm_resource_group.group.id
}