#!/bin/sh
/usr/bin/acpi -b | /usr/bin/awk -F'[,:%]' '{print $2, $3}' | (
        read -r status capacity
        if [ "$status" = Discharging ] && [ "$capacity" -lt 20 ]; then
                /usr/bin/systemctl suspend
        fi
)

#systemctl start battery.timer
#systemctl enable battery.timer
