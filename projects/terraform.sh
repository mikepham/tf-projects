#!/bin/bash

ACTION=${1:-plan}
WORKSPACE=${2:-${TRAVIS_BRANCH:-"default"}}

PLANFILE="terraform.plan"

terraform init
terraform workspace select $WORKSPACE

if [ "$ACTION" = "apply" ]; then
  if [ ! -f $PLANFILE ]; then
    echo "Plan file $PLANFILE not found. Did you run $(plan) first?"
    exit 100
  fi

  terraform apply -auto-approve $PLANFILE
  rm $PLANFILE
  exit
fi

if [ "$ACTION" = "plan" ]; then
  terraform plan -out=$PLANFILE
  exit
fi
