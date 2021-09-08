#!/bin/bash
primary="jp-osa"
secondary="jp-tok"

ibmcloud target -r $primary
while read i
    do ibmcloud is instance-delete $i -f
done < vsis-primary-ids.txt


ibmcloud target -r $secondary
while read i
    do ibmcloud is instance-delete $i -f
done < vsis-secondary-ids.txt