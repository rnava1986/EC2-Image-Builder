#!/usr/bin/env bash
set -e

# Validate Terraform files
terraform init
terraform validate
terraform plan
terraform apply -auto-approve

output_value=$(terraform output -raw ami_id)
echo "Output value: ${output_value}"
amiId=""
# Init creation AMI
initCreationAmi=$(aws imagebuilder start-image-pipeline-execution --image-pipeline-arn ${output_value} --query "imageBuildVersionArn" --output text)
echo "New Building AMI: ${initCreationAmi}"
# Status Creation AMI
statusAmi=$(aws imagebuilder get-image --image-build-version-arn "${initCreationAmi}" --query "image.state.status" --output text)

# Status Creation AMI for Amazon Linux 2
while [[ "${statusAmi}" == "BUILDING" || "${statusAmi}" == "TESTING" ]]; do
    echo "Creating new GOLDEN AMI for Amazon Linux 2 - Status: ${statusAmi}"
    statusAmi=$(aws imagebuilder get-image --image-build-version-arn "${initCreationAmi}" --query "image.state.status" --output text)

  if [[ "${statusAmi}" == "AVAILABLE" ]]; then
    echo "New status for Creation AMI: ${statusAmi}"
    amiId=$(aws imagebuilder get-image --image-build-version-arn "${initCreationAmi}" --query "image.outputResources.amis[].image" --output text)
    echo "AMI ID: ${amiId}"
    break
  elif [[ "${statusAmi}" == "FAILED" ]]; then
    echo ""
    echo ""
    echo "Error creating new GOLDEN AMI"
    echo "Status: ${statusAmi}"
    echo ""
    echo ""
    exit 1  
  fi

  sleep 60
done