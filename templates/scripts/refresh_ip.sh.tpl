#!/bin/bash

DIR="../../../terraform/"
VAR_FILE="variables/${workspace}.tfvars"

echo 'Refreshing external ip address...'
terraform -chdir="$DIR" workspace select ${workspace}
terraform -chdir="$DIR" destroy -var-file="$VAR_FILE" -target=aws_eip.external_ip
terraform -chdir="$DIR" plan -var-file="$VAR_FILE"
terraform -chdir="$DIR" apply -var-file="$VAR_FILE" -auto-approve