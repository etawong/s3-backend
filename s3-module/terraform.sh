#!/bin/bash

#enable debugging mode
set -x

# set the TF_LOG environment variable to "DEBUG. This instructs Terraform to produce detailed debug-level log messages
# Also set the TF_LOG_PATH environment variable to "./terraform.log."
export TF_LOG="DEBUG"
export TF_LOG_PATH="./terraform.log"

ENV=prod
TF_PLAN="${ENV}".tfplan


# check if checkov and tfsec are installed, if not, install them.
# List of tools to check and install
tools=("checkov" "tfsec")

# Function to check and install a tool using pip
check_and_install_tool_pip() {
    tool_name="$1"
    echo "Checking if $tool_name is installed..."
    if command -v "$tool_name" &> /dev/null; then
        echo "$tool_name is already installed."
    else
        echo "$tool_name is not installed. Installing..."
        if pip install "$tool_name"; then
            echo "$tool_name has been successfully installed."
        else
            echo "Error: Failed to install $tool_name."
        fi
    fi
}

# Function to check and install a tool using Chocolatey
check_and_install_tool_choco() {
    tool_name="$1"
    echo "Checking if $tool_name is installed..."
    if command -v "$tool_name" &> /dev/null; then
        echo "$tool_name is already installed."
    else
        echo "$tool_name is not installed. Installing..."
        if choco install "$tool_name" -y; then
            echo "$tool_name has been successfully installed."
        else
            echo "Error: Failed to install $tool_name using Chocolatey."
        fi
    fi
}

# Loop through the list of tools and check/install them using the appropriate method
for tool in "${tools[@]}"; do
    if [ "$tool" == "checkov" ]; then
        check_and_install_tool_pip "$tool"
    elif [ "$tool" == "tfsec" ]; then
        check_and_install_tool_choco "$tool"
    else
        echo "Error: Unsupported tool - $tool."
    fi
done

# verify if .terraform directory exists and delete it.
[ -d .terraform ] && rm -rf .terraform
rm -f *.tfplan
sleep 2

# Your terraform commands
terraform fmt -recursive
terraform init
terraform validate
terraform plan -out=${TF_PLAN}

# Display detailed results about the resources in json format.
terraform show -json ${TF_PLAN}  | jq '.' > ${TF_PLAN}.json
#tfsec .
checkov -f ${TF_PLAN}.json

if [ "$?" -eq "0" ]
then
    echo "Your configuration is valid"
else
    echo "Your code needs review"
    exit 1 # exit 1 means it's going to fail the script
fi

terraform plan -out=${TF_PLAN}

if [ ! -f "${TF_PLAN}" ]
then
    echo "\*\*\*The plan does not exist. Exiting\*\*\*"
    exit 1
fi
