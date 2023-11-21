#!/bin/bash

print_usage() {
  echo "Error with command!"
  echo "Usage: uptime-check.sh <host_ip> <host_name> <discord_webhook_url>"
}

host_ip=$1
host_name=$2
discord_webhook_url=$3

if [[ -z "$host_ip" || -z "$host_name" || -z "$discord_webhook_url" ]]; then
  print_usage
fi

failure_data=$(cat <<EOF
{
  "username": "Uptime Check Cron Job",
  "content": "@here",
  "embeds": [
    {
          "title": "${host_name} is down!",
      "description": "${host_name} (${host_ip}) is down!.",
          "color": 16711680
        }
  ]
}
EOF
)

ping -c 5 "$host_ip" || curl -H "Accept: application/json" -H "Content-Type:application/json" \
-X POST "$discord_webhook_url" \
--data "$failure_data"