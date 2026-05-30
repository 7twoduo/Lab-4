#!/bin/bash
set -Eeuo pipefail

trap 'echo "ERROR on line $LINENO"; echo "Command failed: $BASH_COMMAND"; echo "Current directory: $PWD"; exit 1' ERR

#####################################################################
#      BUILDING THE CONNECTIONS FROM AWS TO AWS AND AWS TO GCP
#      THE TGW AND VPN CONNECTIONS IN THE HUBS
#####################################################################

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

set_true() {
  local file="$1"
  local line="$2"

  sed -i "${line}c\  default     = true" "$file"
  sed -n "${line}p" "$file"
}

apply_here() {
  echo "Running terraform apply in: $PWD"
  terraform apply -auto-approve
}

#####################################################################
# JAPAN - TGW PEERING START
#####################################################################

echo "Moving to JAPAN directory"
cd "$ROOT_DIR/JAPAN"

CONTROL_FILE="4-control.tf"
FIRST_WORKFLOW_LINE=18
TRANSIT_PEERING_LINE=29

echo "Enabling firsts_workflow_enabled in JAPAN"
set_true "$CONTROL_FILE" "$FIRST_WORKFLOW_LINE"

echo "Enabling transit_peering_enabled in JAPAN"
set_true "$CONTROL_FILE" "$TRANSIT_PEERING_LINE"

apply_here

echo "JAPAN Changes applied"
echo "BUILT TRANSIT GATEWAY PEER FROM AWS TO AWS"

#####################################################################
# SAO-PAULO - ACCEPT TGW PEERING
#####################################################################

echo "Moving to Sao-Paulo directory"
cd "$ROOT_DIR/Sao-Paulo"

CONTROL_FILE="4-control.tf"
TRANSIT_PEERING_LINE=22
TRANSIT_PEERING_ROUTE_LINE=28

echo "Enabling transit_peering_enabled in Sao-Paulo"
set_true "$CONTROL_FILE" "$TRANSIT_PEERING_LINE"

apply_here

echo "Enabling transit-peering-route in Sao-Paulo"
set_true "$CONTROL_FILE" "$TRANSIT_PEERING_ROUTE_LINE"

apply_here

echo "SAO PAULO Changes applied"
echo "ACCEPTING TGW PEERING FROM AWS TO AWS"

#####################################################################
# JAPAN - ROUTES TO OTHER AWS ROUTES
#####################################################################

echo "Moving back to JAPAN directory"
cd "$ROOT_DIR/JAPAN"

CONTROL_FILE="4-control.tf"
TRANSIT_PEERING_ROUTE_LINE=35

echo "Enabling transit-peering-route in JAPAN"
set_true "$CONTROL_FILE" "$TRANSIT_PEERING_ROUTE_LINE"

apply_here

echo "JAPAN Changes applied"
echo "BUILDING AWS ROUTE TABLES TO THE OTHER ROUTES IN JAPAN......"

#####################################################################
# IOWA - INITIALIZE HA VPN
#####################################################################

echo "Moving to IOWA directory"
cd "$ROOT_DIR/IOWA"

CONTROL_FILE="4-control.tf"
IOWA_WORKFLOW_LINE=16

echo "Enabling IOWA workflow"
set_true "$CONTROL_FILE" "$IOWA_WORKFLOW_LINE"

apply_here

echo "IOWA Changes applied"
echo "INITIALIZING THE HA-VPN FOR AWS TO USE FOR VPN.........."

#####################################################################
# JAPAN - AWS SIDE VPN TO GCP
#####################################################################

echo "Moving back to JAPAN directory"
cd "$ROOT_DIR/JAPAN"

CONTROL_FILE="4-control.tf"

FIRST_WORKFLOW_LINE=44
SECOND_WORKFLOW_LINE=52
THREE_WORKFLOW_LINE=60

echo "Enabling JAPAN first_workflow_enabled"
set_true "$CONTROL_FILE" "$FIRST_WORKFLOW_LINE"
apply_here

echo "Enabling JAPAN second_workflow_enabled"
set_true "$CONTROL_FILE" "$SECOND_WORKFLOW_LINE"
apply_here

echo "Enabling JAPAN three_workflow_enabled"
set_true "$CONTROL_FILE" "$THREE_WORKFLOW_LINE"
apply_here

echo "JAPAN Changes applied"
echo "BUILT JAPANS AWS SIDE VPN TO GCP WHICH WILL BE USED FOR GCP VPN............"

#####################################################################
# IOWA - GCP VPN TO AWS SIDE
#####################################################################

echo "Moving back to IOWA directory"
cd "$ROOT_DIR/IOWA"

CONTROL_FILE="4-control.tf"
IOWA_SECOND_WORKFLOW_LINE=22

echo "Enabling IOWA line 22"
set_true "$CONTROL_FILE" "$IOWA_SECOND_WORKFLOW_LINE"

apply_here

echo "IOWA Changes applied"
echo "BUILT IOWA GCP VPN TO AWS SIDE ALONG WITH ALL THE ROUTES AND EVERYTHING......"

echo "All TGW/VPN connection steps completed successfully"