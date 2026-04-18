#!/bin/bash
# Get the first reachable device name
device_info=$(kdeconnect-cli -a --id-name | head -n 1)

if [ -z "$device_info" ]; then
    echo "{\"text\": \"No Device\", \"class\": \"disconnected\"}"
else
    # Extract the name (format is usually ID: Name)
    device_name=$(echo "$device_info" | cut -d' ' -f2-)
    echo "{\"text\": \"$device_name\", \"class\": \"connected\"}"
fi