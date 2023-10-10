#!/usr/bin/env sh
# Functions

source /common.sh

# Wireguard
# https://wiki.alpinelinux.org/wiki/Configure_a_Wireguard_interface_(wg)
WG0_DISABLED=${WG0_DISABLED:-no}
WG0_CONFIG=/etc/wireguard/wg0.conf
WG0_PING_PERIOD=10000 # ms

function start_wireguard() {
    if [ -r $WG0_CONFIG ] ; then
        WG0_ENDPOINT=$(cat $WG0_CONFIG | grep Endpoint | sed s/\ //g | cut -d= -f2)
        WG0_ADDRESS=$(cat $WG0_CONFIG | grep Address | sed s/\ //g | cut -d= -f2)
        WG0_PUBLICKEY=$(cat $WG0_CONFIG | grep PublicKey | sed s/\ //g | cut -d= -f2)
        WG0_GATEWAY=$(cat $WG0_CONFIG | grep CheckGateway | sed s/\ //g | cut -d= -f2)
        _info "Initiating Wireguard Controller"
        echo "      Endpoint: $WG0_ENDPOINT"
        echo "    My Address: $WG0_ADDRESS"
        echo " My Public Key: $WG0_PUBLICKEY"
        wg-quick up wg0
        sleep 2
        wg show
    else
      _warn "Wireguard configuration not found!"
    fi
}

if [ "${WG0_DISABLED}" != "yes" ] ; then
    start_wireguard
fi
