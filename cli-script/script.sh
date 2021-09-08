#!/bin/bash
delete=""
delete2=""

# Variables necesarias para el despliegue
# Dallas
vpcdal="deploy100vsidal"
subnetdal="deploy100vsidal-subnet"
keydal="dalkey"

# Washington
vpcwdc="deploy100vsiwdc"
subnetwdc="deploy100vsiwdc-subnet"
keywdc="wdckey"

resourcegroup="modernizacion-rg"

profile="bx2-2x8"
ibmcloud target -r us-south
imagedalid=$(ibmcloud is images | grep -i "ibm-centos-8.*available.*amd64.*public" | cut -d" " -f1)
vpcdalid=$(ibmcloud is vpcs | grep -i $vpcdal | cut -d" " -f1)
keydalid=$(ibmcloud is keys | grep -i $keydal | cut -d" " -f1)
subnetdalid=$(ibmcloud is subnets | grep -i $subnetdal | cut -d" " -f1)

for i in {1..10}
do
   var1dal=$(ibmcloud is instance-create cce-dall-vsis-$i $vpcdalid us-south-1 bx2-2x8 $subnetdalid --image-id $imagedalid --key-ids $keydalid --resource-group-name $resourcegroup)
   var2dal=${var1dal/Name */}
   var2dal=${var2dal/ /}
   delete="${var2dal/*ID /} $delete"
done
echo $delete

ibmcloud target -r us-east
imagewdcid=$(ibmcloud is images | grep -i "ibm-centos-8.*available.*amd64.*public" | cut -d" " -f1)
vpcwdcid=$(ibmcloud is vpcs | grep -i $vpcwdc | cut -d" " -f1)
keywdcid=$(ibmcloud is keys | grep -i $keywdc | cut -d" " -f1)
subnetwdcid=$(ibmcloud is subnets | grep -i $subnetwdc | cut -d" " -f1)

for i in {1..10}
do
   var1wdc=$(ibmcloud is instance-create cce-wdc-vsis-$i $vpcwdcid us-east-1 bx2-2x8 $subnetwdcid --image-id $imagewdcid --key-ids $keywdcid --resource-group-name $resourcegroup)
   var2wdc=${var1wdc/Name */}
   var2wdc=${var2wdc/ /}
   delete2="${var2wdc/*ID /} $delete2"
done
echo $delete2