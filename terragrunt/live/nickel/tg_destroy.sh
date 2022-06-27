#!/usr/bin/env bash

CWD=$(pwd)

find "${CWD}" -name ".terragrunt-cache" -type d -exec rm -rf {} \;
find "${CWD}" -name ".terraform.lock.hcl" -type f -exec rm -rf {} \;

TG=(
  "${CWD}/sa-east-1/br/tools/eks-addons/"
  "${CWD}/sa-east-1/br/tools/eks-addons-critical/"
  "${CWD}/sa-east-1/br/tools/aws-auth/"
  "${CWD}/sa-east-1/br/tools/eks/"
  "${CWD}/sa-east-1/br/tools/vpc/"
  "${CWD}/sa-east-1/br/tools/encryption-config/"
)

for tg_dir in "${TG[@]}";
do
  echo "========================================================================================================================"
  echo "Destroying ${tg_dir}"
  echo "========================================================================================================================"
  echo -e ""
  cd "${tg_dir}"
  terragrunt destroy -auto-approve
  cd "${CWD}"
  echo -e ""
done
