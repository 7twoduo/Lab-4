#!/bin/bash
set -Eeuo pipefail

trap 'echo "ERROR on line $LINENO"; echo "Command failed: $BASH_COMMAND"; echo "Current directory: $PWD"; exit 1' ERR

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

destroy_dir() {
  local dir_name="$1"
  local label="$2"

  cd "$ROOT_DIR/$dir_name"

  echo "Destroying ${label}"
  echo "Current directory: $PWD"

  terraform init
  terraform destroy -auto-approve

  echo "${label} destroy completed"
}

wait_for_job() {
  local pid="$1"
  local label="$2"

  if ! wait "$pid"; then
    echo "ERROR: ${label} failed"
    exit 1
  fi

  echo "${label} completed successfully"
}

#################################################
#      DESTROY IOWA AND SAO-PAULO IN PARALLEL
#################################################

(
  set -Eeuo pipefail
  destroy_dir "IOWA" "IOWA"
) &
IOWA_PID=$!

(
  set -Eeuo pipefail
  destroy_dir "Sao-Paulo" "Sao-Paulo"
) &
SAO_PID=$!

wait_for_job "$IOWA_PID" "IOWA destroy"
wait_for_job "$SAO_PID" "Sao-Paulo destroy"

echo "IOWA and Sao-Paulo destroy completed"

#################################################
#      DESTROY JAPAN AFTER IOWA AND SAO-PAULO
#################################################

#################################################
#      REVERSING BUILD FLAGS AFTER DESTROY
#      ONLY CHANGING 4-control.tf FILES
#################################################

reset_japan() {
  echo "Resetting JAPAN flags"

  cd "$ROOT_DIR/JAPAN"

  CONTROL_FILE="4-control.tf"

  FIRST_WORKFLOW_LINE=18
  TRANSIT_PEERING_LINE=29
  TRANSIT_PEERING_ROUTE_LINE=35
  JAPAN_FIRST_WORKFLOW_LINE=44
  JAPAN_SECOND_WORKFLOW_LINE=52
  JAPAN_THREE_WORKFLOW_LINE=60

  sed -i "${FIRST_WORKFLOW_LINE}c\  default     = false" "$CONTROL_FILE"
  sed -i "${TRANSIT_PEERING_LINE}c\  default     = false" "$CONTROL_FILE"
  sed -i "${TRANSIT_PEERING_ROUTE_LINE}c\  default     = false" "$CONTROL_FILE"
  sed -i "${JAPAN_FIRST_WORKFLOW_LINE}c\  default     = false" "$CONTROL_FILE"
  sed -i "${JAPAN_SECOND_WORKFLOW_LINE}c\  default     = false" "$CONTROL_FILE"
  sed -i "${JAPAN_THREE_WORKFLOW_LINE}c\  default     = false" "$CONTROL_FILE"

  echo "JAPAN reset complete"
  sed -n "${FIRST_WORKFLOW_LINE}p;${TRANSIT_PEERING_LINE}p;${TRANSIT_PEERING_ROUTE_LINE}p;${JAPAN_FIRST_WORKFLOW_LINE}p;${JAPAN_SECOND_WORKFLOW_LINE}p;${JAPAN_THREE_WORKFLOW_LINE}p" "$CONTROL_FILE"
}

destroy_dir "JAPAN" "JAPAN"

reset_sao_paulo() {
  echo "Resetting Sao-Paulo flags and import block"

  cd "$ROOT_DIR/Sao-Paulo"

  CONTROL_FILE="4-control.tf"

  TRANSIT_PEERING_LINE=22
  TRANSIT_PEERING_ROUTE_LINE=28
  IMPORT_START_LINE=14
  IMPORT_END_LINE=17

  sed -i "${TRANSIT_PEERING_LINE}c\  default     = false" "$CONTROL_FILE"
  sed -i "${TRANSIT_PEERING_ROUTE_LINE}c\  default     = false" "$CONTROL_FILE"

  echo "Commenting Sao-Paulo import block lines 14-17 if needed"
  sed -i "${IMPORT_START_LINE},${IMPORT_END_LINE}{/^[[:space:]]*$/!{/^[[:space:]]*#/!s/^/#/}}" "$CONTROL_FILE"

  echo "Sao-Paulo reset complete"
  sed -n "${IMPORT_START_LINE},${IMPORT_END_LINE}p;${TRANSIT_PEERING_LINE}p;${TRANSIT_PEERING_ROUTE_LINE}p" "$CONTROL_FILE"
}

reset_iowa() {
  echo "Resetting IOWA flags"

  cd "$ROOT_DIR/IOWA"

  CONTROL_FILE="4-control.tf"

  IOWA_WORKFLOW_LINE=16
  IOWA_SECOND_WORKFLOW_LINE=22

  sed -i "${IOWA_WORKFLOW_LINE}c\  default     = false" "$CONTROL_FILE"
  sed -i "${IOWA_SECOND_WORKFLOW_LINE}c\  default     = false" "$CONTROL_FILE"

  echo "IOWA reset complete"
  sed -n "${IOWA_WORKFLOW_LINE}p;${IOWA_SECOND_WORKFLOW_LINE}p" "$CONTROL_FILE"
}

#################################################
#      RESET FILES IN PARALLEL
#################################################

(
  set -Eeuo pipefail
  reset_japan
) &
JAPAN_RESET_PID=$!

(
  set -Eeuo pipefail
  reset_sao_paulo
) &
SAO_RESET_PID=$!

(
  set -Eeuo pipefail
  reset_iowa
) &
IOWA_RESET_PID=$!

wait_for_job "$JAPAN_RESET_PID" "JAPAN reset"
wait_for_job "$SAO_RESET_PID" "Sao-Paulo reset"
wait_for_job "$IOWA_RESET_PID" "IOWA reset"

echo "All build flags reset to false"

banner=(
'                uuuuuuu'
'             uu$$$$$$$$$$$uu'
'          uu$$$$$$$$$$$$$$$$$uu'
'         u$$$$$$$$$$$$$$$$$$$$$u'
'        u$$$$$$$$$$$$$$$$$$$$$$$u'
'       u$$$$$$$$$$$$$$$$$$$$$$$$$u'
'       u$$$$$$$$$$$$$$$$$$$$$$$$$u'
'       u$$$$$$"   "$$$"   "$$$$$u'
'       "$$$$"      u$u       $$$$"'
'        $$$u       u$u       u$$$'
'        $$$u      u$$$u      u$$$'
'         "$$$$uu$$$   $$$uu$$$$"'
'          "$$$$$$$"   "$$$$$$$"'
'            u$$$$$$$u$$$$$$$u'
'             u$"$"$"$"$"$"$u'
'  uuu        $$u$ $ $ $ $u$$       uuu'
' u$$$$        $$$$$u$u$u$$$       u$$$$'
'  $$$$$uu      "$$$$$$$$$"     uu$$$$$$'
'u$$$$$$$$$$$uu    """""    uuuu$$$$$$$$$$'
'$$$$"""$$$$$$$$$$uuu   uu$$$$$$$$$"""$$$"'
' """      ""$$$$$$$$$$$uu ""$"""'
'           uuuu ""$$$$$$$$$$uuu'
'  u$$$uuu$$$$$$$$$uu ""$$$$$$$$$$$uuu$$$'
'  $$$$$$$$$$""""           ""$$$$$$$$$$$"'
'   "$$$$$"                      ""$$$$""'
'     $$$"                         $$$$"'
''
'              DESTROY COMPLETE'
)

for line in "${banner[@]}"; do
  echo "$line"
  sleep 0.05
done
