
#####################################################################
#      REVERSING BUILD FLAGS AFTER DESTROY IN PARALLEL
#      ONLY CHANGING 4-control.tf FILES
#####################################################################

echo "Moving to root directory"
cd ..

ROOT_DIR="$PWD"

#####################################################################
# JAPAN RESET
#####################################################################

(
  echo "Resetting JAPAN flags"

  cd "$ROOT_DIR/JAPAN" || exit 1

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
) &

#####################################################################
# SAO-PAULO RESET
#####################################################################

(
  echo "Resetting Sao-Paulo flags"

  cd "$ROOT_DIR/Sao-Paulo" || exit 1

  CONTROL_FILE="4-control.tf"

  TRANSIT_PEERING_LINE=22
  TRANSIT_PEERING_ROUTE_LINE=28

  sed -i "${TRANSIT_PEERING_LINE}c\  default     = false" "$CONTROL_FILE"
  sed -i "${TRANSIT_PEERING_ROUTE_LINE}c\  default     = false" "$CONTROL_FILE"

  echo "Sao-Paulo reset complete"
  sed -n "${TRANSIT_PEERING_LINE}p;${TRANSIT_PEERING_ROUTE_LINE}p" "$CONTROL_FILE"
) &

#####################################################################
# IOWA RESET
#####################################################################

(
  echo "Resetting IOWA flags"

  cd "$ROOT_DIR/IOWA" || exit 1

  CONTROL_FILE="4-control.tf"

  IOWA_WORKFLOW_LINE=16
  IOWA_SECOND_WORKFLOW_LINE=22

  sed -i "${IOWA_WORKFLOW_LINE}c\  default     = false" "$CONTROL_FILE"
  sed -i "${IOWA_SECOND_WORKFLOW_LINE}c\  default     = false" "$CONTROL_FILE"

  echo "IOWA reset complete"
  sed -n "${IOWA_WORKFLOW_LINE}p;${IOWA_SECOND_WORKFLOW_LINE}p" "$CONTROL_FILE"
) &

####################################################################################
#         FIXING A LOAD BALANCER PROBLEM THAT MIGHT OCCUR
####################################################################################
(
  echo "Resetting Sao-Paulo flags"

  cd "$ROOT_DIR/Sao-Paulo" || exit 1

  CONTROL_FILE="4-control.tf"

  IMPORT_START_LINE=14
  IMPORT_END_LINE=17

  echo "Commenting Sao-Paulo import block lines 14-17 if needed"
  sed -i "${IMPORT_START_LINE},${IMPORT_END_LINE}{/^[[:space:]]*$/!{/^[[:space:]]*#/!s/^/#/}}" "$CONTROL_FILE"

  echo "Sao-Paulo reset complete"
  sed -n "${IMPORT_START_LINE},${IMPORT_END_LINE}p;${TRANSIT_PEERING_LINE}p;${TRANSIT_PEERING_ROUTE_LINE}p" "$CONTROL_FILE"
) &

wait

echo "All build flags reset to false"