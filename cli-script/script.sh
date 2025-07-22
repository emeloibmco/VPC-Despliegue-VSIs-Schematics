#!/bin/bash

#####################################################################################################
# Variables de despliegue
#####################################################################################################

# Regiones de despliegue
primary="us-south"
secondary="us-east"

# Primary
vpc_primary="vpc-dall"
subnet_primary="sn-20250721-01"
key_primary="key-dall"

# Secondary
vpc_secondary="vpc-wash"
subnet_secondary="sn-20250722-01"
key_secondary="key-dall"

BaseName="vsi"
resourcegroup="cce-valtadria"
profile="cx2-4x8"

#####################################################################################################
# No editar
#####################################################################################################

# Obtener imagen pública de CentOS
ibmcloud target -r $primary
imageid=$(ibmcloud is images --visibility public | grep -Ei "ibm-centos.*stream.*9.*available.*amd64" | head -n1 | awk '{print $1}')

# Obtener recursos región primaria
vpcid_primary=$(ibmcloud is vpcs | grep -i "$vpc_primary" | awk '{print $1}')
keyid_primary=$(ibmcloud is keys | grep -i "$key_primary" | awk '{print $1}')
subnetid_primary=$(ibmcloud is subnets | grep -i "$subnet_primary" | awk '{print $1}')

# Obtener recursos región secundaria
ibmcloud target -r $secondary
imageid_sec=$(ibmcloud is images --visibility public | grep -Ei "ibm-centos.*stream.*9.*available.*amd64" | head -n1 | awk '{print $1}')
vpcid_secondary=$(ibmcloud is vpcs | grep -i "$vpc_secondary" | awk '{print $1}')
keyid_secondary=$(ibmcloud is keys | grep -i "$key_secondary" | awk '{print $1}')
subnetid_secondary=$(ibmcloud is subnets | grep -i "$subnet_secondary" | awk '{print $1}')

# Crear instancias en primaria
ibmcloud target -r $primary -g "$resourcegroup"
> vsis-primary-ids.txt

for i in {1..50}; do
  (
    name="$BaseName-$primary-$i"
    output=$(ibmcloud is instance-create "$name" "$vpcid_primary" "$primary-1" "$profile" "$subnetid_primary" --image "$imageid" --keys "$keyid_primary" --resource-group-name "$resourcegroup")
    echo "Instancia $name Creada"
    id=$(echo "$output" | grep -oP '(?<=ID\s)[a-z0-9\-]+')
    echo "$id" > "tmp-id-primary-$i.txt"
  ) &
done

wait

for i in {50..1}; do
  if [ -f "tmp-id-primary-$i.txt" ]; then
    cat "tmp-id-primary-$i.txt"
  fi
done > vsis-primary-ids.txt

rm tmp-id-primary-*.txt

# Crear instancias en secundaria
ibmcloud target -r $secondary -g "$resourcegroup"
> vsis-secondary-ids.txt

for i in {1..50}; do
  (
    name="$BaseName-$secondary-$i"
    output=$(ibmcloud is instance-create "$name" "$vpcid_secondary" "$secondary-1" "$profile" "$subnetid_secondary" --image "$imageid_sec" --keys "$keyid_secondary" --resource-group-name "$resourcegroup")
    echo "Instancia $name Creada"
    id=$(echo "$output" | grep -oP '(?<=ID\s)[a-z0-9\-]+')
    echo "$id" > "tmp-id-secondary-$i.txt"
  ) &
done

wait

for i in {50..1}; do
  if [ -f "tmp-id-secondary-$i.txt" ]; then
    cat "tmp-id-secondary-$i.txt"
  fi
done > vsis-secondary-ids.txt

rm tmp-id-secondary-*.txt
