#!/bin/bash
while read i
    do ibmcloud is instance-delete $i -f
done < vsis-primary-ids.txt

while read i
    do ibmcloud is instance-delete $i -f
done < vsis-secondary-ids.txt