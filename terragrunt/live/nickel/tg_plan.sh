#!/usr/bin/env bash

CWD=$(pwd)

find "${CWD}" -name ".terragrunt-cache" -type d -exec rm -rfv {} \;
find "${CWD}" -name ".terraform.lock.hcl" -type f -exec rm -rfv {} \;

TG=(
  "${CWD}/sa-east-1/br/tools/encryption-config/"
  "${CWD}/sa-east-1/br/tools/vpc/"
  "${CWD}/sa-east-1/br/tools/eks/"
  "${CWD}/sa-east-1/br/tools/aws-auth/"
  "${CWD}/sa-east-1/br/tools/eks-addons-critical/"
  "${CWD}/sa-east-1/br/tools/eks-addons/"
)

for tg_dir in "${TG[@]}";
do
  echo "========================================================================================================================"
  echo "Applying ${tg_dir}"
  echo "========================================================================================================================"
  echo -e ""
  cd "${tg_dir}"
  terragrunt plan
  cd "${CWD}"
  echo -e ""
done
