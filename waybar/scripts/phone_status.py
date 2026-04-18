#!/usr/bin/env python3
import subprocess
import json
   try:
       # Get the first reachable device name
       result = subprocess.check_output(["kdeconnect-cli", "-a", "--id-name-only"], text=True).strip()
       if result:
           # Extract just the name (format: ID Name)
           device_name = " ".join(result.split()[1:])
           print(json.dumps({"text": device_name, "class": "connected"}))
       else:
           print(json.dumps({"text": "No Device", "class": "disconnected"}))except Exception:
       print(json.dumps({"text": "Error", "class": "error"}))
