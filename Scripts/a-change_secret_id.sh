# ############################################################
# #      BUILDING THE SECRET MANAGER ID CUZ ITS A BIG PROBLEM
# ############################################################

# echo "Moving to root directory"
# cd ..

# echo "Moving to JAPAN directory"
# cd JAPAN

# echo "Setting random mysql number"
# SECRET_NUM=$(printf "%03d" "$(( RANDOM % 1000 ))")
# SECRET_LOCATION="lab/rds/mysql${SECRET_NUM}"

# JAPAN_CONTROL_FILE="4-control.tf"
# JAPAN_CONTROL_SECRET_LINE=9

# echo "Updating JAPAN terraform secret location"
# sed -i "${JAPAN_CONTROL_SECRET_LINE}c\  default     = \"${SECRET_LOCATION}\"" "$JAPAN_CONTROL_FILE"

# echo "Moving back to root directory"

# ############################################################
# #      TGW BIG PROBLEMO PROBLEMO PROBLEMO 
# ############################################################

# cd ..

# echo "Moving to Sao-Paulo directory"
# cd Sao-Paulo

# SAO_CONTROL_FILE="4-control.tf"
# SAO_CONTROL_SECRET_LINE=7

# PY_SECRET_LINE=18
# SERVICE_SECRET_LINE=206

# echo "Updating Sao-Paulo terraform secret location"
# sed -i "${SAO_CONTROL_SECRET_LINE}c\  default     = \"${SECRET_LOCATION}\"" "$SAO_CONTROL_FILE"

# echo "Updating Sao-Paulo Python SECRET_ID"
# sed -i "${PY_SECRET_LINE}c\SECRET_ID = os.environ.get(\"SECRET_ID\", \"${SECRET_LOCATION}\")" userdata.sh

# echo "Updating Sao-Paulo systemd SECRET_ID"
# sed -i "${SERVICE_SECRET_LINE}c\Environment=SECRET_ID=${SECRET_LOCATION}" userdata.sh

# echo "Updated secret location to: ${SECRET_LOCATION}"

# echo "Moving back to root directory"
# cd ..

# ############################################################
# #      RANDOMIZE SAO-PAULO TGW NAME
# ############################################################

# echo "Moving to Sao-Paulo directory"
# cd Sao-Paulo

# SAO_CONTROL_FILE="4-control.tf"
# SAO_CONTROL_SECRET_LINE=7

# PY_SECRET_LINE=18
# SERVICE_SECRET_LINE=206

# echo "Updating Sao-Paulo terraform secret location"
# sed -i "${SAO_CONTROL_SECRET_LINE}c\  default     = \"${SECRET_LOCATION}\"" "$SAO_CONTROL_FILE"

# echo "Updating Sao-Paulo Python SECRET_ID"
# sed -i "${PY_SECRET_LINE}c\SECRET_ID = os.environ.get(\"SECRET_ID\", \"${SECRET_LOCATION}\")" userdata.sh

# echo "Updating Sao-Paulo systemd SECRET_ID"
# sed -i "${SERVICE_SECRET_LINE}c\Environment=SECRET_ID=${SECRET_LOCATION}" userdata.sh

# echo "Updated secret location to: ${SECRET_LOCATION}"


# ############################################################
# #      RANDOMIZE SAO-PAULO TGW NAME
# ############################################################

# TGW_NAME="liberdade-tgw${SECRET_NUM}"

# SAO_CONTROL_FILE="4-control.tf"
# SAO_TGW_NAME_LINE=40

# echo "Updating Sao-Paulo TGW Name tag"
# sed -i "${SAO_TGW_NAME_LINE}c\    Name = \"${TGW_NAME}\"" "$SAO_CONTROL_FILE"

# echo "Updated Sao-Paulo TGW name to: ${TGW_NAME}"

# echo "Verifying Sao-Paulo TGW name"
# sed -n "${SAO_TGW_NAME_LINE}p" "$SAO_CONTROL_FILE"

# ############################################################
# #      RANDOMIZE SAO-PAULO TGW PEERING ATTACHMENT NAME
# ############################################################

# PEER_NAME="shinjuku-to-liberdade-peer${SECRET_NUM}"

# SAO_CONTROL_FILE="4-control.tf"
# SAO_PEER_NAME_LINE=47

# echo "Updating Sao-Paulo TGW peer attachment Name tag"
# sed -i "${SAO_PEER_NAME_LINE}c\    Name = \"${PEER_NAME}\"" "$SAO_CONTROL_FILE"

# echo "Updated Sao-Paulo TGW peer name to: ${PEER_NAME}"

# echo "Verifying Sao-Paulo TGW peer name"
# sed -n "${SAO_PEER_NAME_LINE}p" "$SAO_CONTROL_FILE"

# echo "Moving back to root directory"
# cd ..
# echo "Moving to JAPAN directory"
# cd JAPAN

# ############################################################
# #      RANDOMIZE JAPAN TGW NAME
# ############################################################

# JAPAN_TGW_NAME="shinjuku-tgw${SECRET_NUM}"

# JAPAN_CONTROL_FILE="4-control.tf"
# JAPAN_TGW_NAME_LINE=73

# echo "Updating JAPAN TGW Name tag"
# sed -i "${JAPAN_TGW_NAME_LINE}c\    Name = \"${JAPAN_TGW_NAME}\"" "$JAPAN_CONTROL_FILE"

# echo "Updated JAPAN TGW name to: ${JAPAN_TGW_NAME}"

# echo "Verifying JAPAN TGW name"
# sed -n "${JAPAN_TGW_NAME_LINE}p" "$JAPAN_CONTROL_FILE"

# ############################################################
# #      UPDATE JAPAN REFERENCES TO SAO-PAULO TGW/PEER NAMES
# ############################################################

# JAPAN_CONTROL_FILE="4-control.tf"

# JAPAN_TGW_LOOKUP_VALUES_LINE=82
# JAPAN_PEER_NAME_LINE=93

# echo "Updating JAPAN TGW lookup values with Sao-Paulo TGW name"
# sed -i "${JAPAN_TGW_LOOKUP_VALUES_LINE}c\    values = [\"${TGW_NAME}\"]" "$JAPAN_CONTROL_FILE"

# echo "Updating JAPAN peer attachment Name tag with Sao-Paulo PEER_NAME"
# sed -i "${JAPAN_PEER_NAME_LINE}c\    Name = \"${PEER_NAME}\"" "$JAPAN_CONTROL_FILE"

# echo "Verifying JAPAN TGW lookup and peer name"
# sed -n "${JAPAN_TGW_LOOKUP_VALUES_LINE}p;${JAPAN_PEER_NAME_LINE}p" "$JAPAN_CONTROL_FILE"

