#!/bin/bash
# This script is used in order to update dynamic DNS
# The script will compare old ip with new new ip and will update iptables rules
# a Crontab should be put in place to update it regurlary
# Should to create a dynamic dns and have a client or a router who can update it to the supplier.

#################################
# SETTINGS
#################################

# DYDNS
# add your own dynamic dns 
DNS=

# Old ip
FILE="/tmp/old_ip.txt"

###################################
# MAIN SCRIPT
###################################

# Check if the file exists and read the old IP address
if [ -f "$FILE" ]; then
    OLD_IP=$(cat "$FILE")
else
    OLD_IP=""
fi

# Current IP address of the DNS
NEW_IP=$(dig +short "$DNS")

# Check if new ip is different from old ip and update iptables rules
# chain is INPUT but could be change to DOCKER-USER / OUTPUT chain

if [ "$NEW_IP" != "$OLD_IP" ]; then
iptables -D INPUT 1
iptables -I INPUT 1 -s $NEW_IP -j ACCEPT -m comment --comment "DYNDNS"

# Save the new ip for next check
echo "$NEW_IP" > "$FILE"

fi
