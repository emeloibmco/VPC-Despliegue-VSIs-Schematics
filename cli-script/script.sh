#!/bin/bash

#####################################################################################################
# Variables de despliegue
#####################################################################################################

#Regiones de despliegue
primary="jp-osa"
secondary="jp-tok"
BaseName="cce-vsi-provisioning"

# Primary
vpcosa="vpc-demo-osa"
subnetosa="subnet-demo-osa"
keyosa="key-demo-osa"

# Secondary
vpctok="vpc-demo-tok"
subnettok="subnet-demo-tok"
keytok="key-demo-tok"

resourcegroup="vpc-demo-rg"

#####################################################################################################
# No editar
#####################################################################################################

idsprimary=""
idssecondary=""
profile="bx2-4x8"
ibmcloud target -r $primary
imageosaid=$(ibmcloud is images | grep -i "ibm-centos-8.*available.*amd64.*public" | cut -d" " -f1)
vpcosaid=$(ibmcloud is vpcs | grep -i $vpcosa | cut -d" " -f1)
keyosaid=$(ibmcloud is keys | grep -i $keyosa | cut -d" " -f1)
subnetosaid=$(ibmcloud is subnets | grep -i $subnetosa | cut -d" " -f1)

for i in {1..10}
do
   var1osa=$(ibmcloud is instance-create $BaseName-primary-$i $vpcosaid $primary-1 $profile $subnetosaid --image-id $imageosaid --key-ids $keyosaid --resource-group-name $resourcegroup)
   echo "Instancia $BaseName-primary-$i Creada"
   var2osa=${var1osa/Name */}
   var2osa=${var2osa/ /}
   idsprimary="${var2osa/*ID /}\n$idsprimary"
done
echo -e $idsprimary > vsis-primary-ids.txt

ibmcloud target -r $secondary
imagetokid=$(ibmcloud is images | grep -i "ibm-centos-8.*available.*amd64.*public" | cut -d" " -f1)
vpctokid=$(ibmcloud is vpcs | grep -i $vpctok | cut -d" " -f1)
keytokid=$(ibmcloud is keys | grep -i $keytok | cut -d" " -f1)
subnettokid=$(ibmcloud is subnets | grep -i $subnettok | cut -d" " -f1)

for i in {1..10}
do
   var1tok=$(ibmcloud is instance-create $BaseName-secondary-$i $vpctokid $secondary-1 $profile $subnettokid --image-id $imagetokid --key-ids $keytokid --resource-group-name $resourcegroup)
   echo "Instancia $BaseName-secondary-$i Creada"
   var2tok=${var1tok/Name */}
   var2tok=${var2tok/ /}
   idssecondary="${var2tok/*ID /}\n$idssecondary"
done
echo -e $idssecondary > vsis-secondary-ids.txt
