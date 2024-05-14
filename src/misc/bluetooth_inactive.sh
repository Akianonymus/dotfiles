#!/bin/bash

# Set inactive time in seconds (10 minutes)
inactive_time=$((10 * 60))

if ! [ "$(command -v bluetoothctl)" ]; then
    exit
fi

while true; do

    # Check if any Bluetooth devices are connected
    connected_devices=$(bluetoothctl info | grep -c "Connected: yes")

    if [ $((connected_devices)) -eq 0 ]; then
        # If no connected devices, decrease timer
        ((inactive_time -= 5))

        if [ $inactive_time -le 0 ]; then
            # Turn off Bluetooth
            rfkill block bluetooth
            break
        fi
    else
        # Reset timer if device connected
        inactive_time=$((10 * 60))
    fi

    # Wait for 5 seconds
    sleep 10
done
