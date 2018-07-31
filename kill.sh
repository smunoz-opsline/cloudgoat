#!/bin/bash

cd terraform && terraform destroy -auto-approve
response=$(aws glue delete-dev-endpoint --endpoint-name "$(< ../tmp/glue_dev_endpoint_name.txt)" --region us-west-2 2>&1)
while [[ $response = *"InvalidInputException"*"is Provisioning"* ]] && sleep 15; do
	response=$(aws glue delete-dev-endpoint --endpoint-name "$(< ../tmp/glue_dev_endpoint_name.txt)" --region us-west-2 2>&1)
	echo "The Glue development endpoint is still being provisioned, which means we can't delete it yet. Trying again in 15 seconds..."
done
echo "Successfully deleted Glue development endpoint: $(< ../tmp/glue_dev_endpoint_name.txt)."
rm ../tmp/allow_cidr.txt
rm ../tmp/glue_role_arn.txt
rm ../tmp/glue_dev_endpoint_name.txt
rm ../credentials.txt
rm ./terraform.tfstate*
rm ./plan.tfout
