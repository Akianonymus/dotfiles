#!/usr/bin/env bash

node_path='/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode'

id="$1"
command="if [[ \$(< ${node_path}) = 1 ]]; then  echo 0 > ${node_path} && kdialog --passivepopup '<br>Conservation Mode: Disabled' 1; else echo 1 > ${node_path} && kdialog --passivepopup '<br>Conservation Mode: Enabled' 1; fi"

while true; do
    status="Disabled" mode="A"
    grep -q 1 "${node_path}" && status="Enabled" && mode="B"

    data="| ${mode} || Conservation Mode: ${status} | $command |"

    qdbus org.kde.plasma.doityourselfbar /id_"$id" \
        org.kde.plasma.doityourselfbar.pass "$data"

    sleep 1s
done
