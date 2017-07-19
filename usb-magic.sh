#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "Usage: usb-magic.sh IP_PHONE NAME_IF_PHONE"
else

    IP_PHONE=$1
    NAME_IF_PHONE=$2

    sudo umount -f /tools /projects /models

    sudo route del default
    sudo route del default
    sudo route add default gw $IP_PHONE $NAME_IF_PHONE
    sudo route add -net 10.94.0.0 netmask 255.255.0.0 gw 10.94.161.1
    sudo route add -net 140.94.0.0 netmask 255.255.0.0 gw 10.94.161.1

    sleep 5
    sudo mount -a

    # useless ?
    #sudo iptables -t nat -A POSTROUTING -o $NAME_IF_PHONE -j MASQUERADE

fi
