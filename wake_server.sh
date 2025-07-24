#!/bin/bash
SERVER_MAC="AA:BB:CC:DD:EE:FF"  # Replace with your server's MAC
SERVER_IP="192.168.0.44"         # Server's IP
SERVER_PORT="8096"               # Port to monitor
INTERFACE="eth0"                 # Check with `ip link`

while true; do
    tcpdump -i $INTERFACE -c 1 -nn tcp port $SERVER_PORT && {
        if ! nc -w 1 -z $SERVER_IP $SERVER_PORT > /dev/null 2>&1; then
            echo "Server is down, sending WoL packet..."
            sudo etherwake -i $INTERFACE $SERVER_MAC
        else
            echo "Server is already awake, skipping WoL."
        fi
    }
    sleep 5
done
