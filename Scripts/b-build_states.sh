#!/bin/bash
set -Eeuo pipefail

trap 'echo "ERROR on line $LINENO"; echo "Command failed: $BASH_COMMAND"; echo "Current directory: $PWD"; exit 1' ERR

#################################################
#      BUILDING THE INITIAL INFRASTRUCTURE
#################################################

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

run_terraform_build() {
  local DIR_NAME="$1"
  local LABEL="$2"

  echo "Moving to ${DIR_NAME}"
  cd "$ROOT_DIR/$DIR_NAME"

  echo "Current directory: $PWD"

  terraform init
  terraform fmt
  terraform validate
  if [ -f "startup.sh.tftpl" ]; then
    echo "[INFO] Found startup.sh.tftpl - removing CRLF line endings"
    sed -i 's/\r$//' startup.sh.tftpl
  else
    echo "[WARN] startup.sh.tftpl not found in $(pwd)"
  fi

  echo "Building ${LABEL}..."
  terraform apply -auto-approve
  echo "DONE Building ${LABEL}...."
}

#################################################
# JAPAN
#################################################

run_terraform_build "JAPAN" "JAPAN AWS"

#################################################
# SAO-PAULO
#################################################

echo "Moving to Sao-Paulo"
cd "$ROOT_DIR/Sao-Paulo"

echo "Current directory: $PWD"

terraform init
terraform fmt
terraform validate

echo "Building SAO PAULO..."
terraform apply -auto-approve
echo "DONE Building SAO PAULO...."

REGION="sa-east-1"
LB_NAME="LoadExternal"
CONTROL_FILE="4-control.tf"

echo "Checking for ASG in Sao-Paulo"
ASG_NAME=$(aws autoscaling describe-auto-scaling-groups \
  --region "$REGION" \
  --query 'AutoScalingGroups[?length(TargetGroupARNs) > `0`].AutoScalingGroupName | [0]' \
  --output text)

echo "ASG found: ${ASG_NAME:-none}"

echo "Looking for Sao-Paulo load balancer ARN"
LB_ARN=$(aws elbv2 describe-load-balancers \
  --region "$REGION" \
  --names "$LB_NAME" \
  --query "LoadBalancers[0].LoadBalancerArn" \
  --output text 2>/dev/null || true)

if [[ -z "$LB_ARN" || "$LB_ARN" == "None" ]]; then
  echo "No LB found by name. Trying newest application load balancer."

  LB_ARN=$(aws elbv2 describe-load-balancers \
    --region "$REGION" \
    --query 'sort_by(LoadBalancers[?Type==`application`], &CreatedTime)[-1].LoadBalancerArn' \
    --output text)
fi

if [[ -z "$LB_ARN" || "$LB_ARN" == "None" ]]; then
  echo "ERROR: No load balancer ARN found in $REGION"
  exit 1
fi

echo "Found LB ARN: $LB_ARN"

echo "Uncommenting lines 14-17"
sed -i '14,17s/^[[:space:]]*#[[:space:]]*//' "$CONTROL_FILE"

echo "Updating line 16 with LB ARN"
sed -i "16c\  id = \"$LB_ARN\"" "$CONTROL_FILE"

echo "Updated import block:"
sed -n '14,17p' "$CONTROL_FILE"

echo "Running Sao-Paulo terraform apply after import update"
terraform apply -auto-approve

#################################################
# IOWA
#################################################

run_terraform_build "IOWA" "IOWA GCP"

echo "Moving to Root Directory"
cd "$ROOT_DIR"

echo "Initial infrastructure build completed successfully"
