#!/bin/bash

if tasklist.exe | grep 'obs' -q
then
  echo -n "🏠 #[fg=colour197]192.168.0.0 #[fg=black]|#[fg=colour197] 📡 255.255.255.256"
else
  # Internal IP
  IP=$(hostname -I | awk {'print $1}')

  PUBLIC_IP=$(curl -4 ifconfig.co)

  if [[ "$PUBLIC_IP" = ";; connection timed out; no servers could be reached" ]]; then 
      PUBLIC_IP="Not Available"
  elif [[ "$PUBLIC_IP" = "" ]]; then
      PUBLIC_IP="No external access"
  else 
      PUBLIC_IP=$(curl -4 ifconfig.co)
  fi

  echo -n "🏠 #[fg=colour197]$IP #[fg=black]|#[fg=colour197] 📡 $PUBLIC_IP"
fi

