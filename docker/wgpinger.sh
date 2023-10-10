#!/usr/bin/env sh
# https://github.com/dennypage/dpinger
LOG_PREFIX=wgpinger.sh
source /common.sh

# Wireguard
# https://wiki.alpinelinux.org/wiki/Configure_a_Wireguard_interface_(wg)
WG0_DISABLED=${WG0_DISABLED:-no}
WG0_CONFIG=/etc/wireguard/wg0.conf
WG0_DPINGER_OPTS=${WG0_DPINGER_OPTS:--s 5s -t 60s -r 10s -L 10%}

function start_wgpinger() {
    if [ -r $WG0_CONFIG ] ; then
        WG0_GATEWAY=$(cat $WG0_CONFIG | grep CheckGateway | sed s/\ //g | cut -d= -f2)
        # exec /usr/bin/dpinger -f -S -i wg0 -s 10s -t 600s -r 0 -L 10% -p /run/dpinger $WG0_GATEWAY
        /usr/bin/dpinger -f -S -i "wg0 $WG0_GATEWAY" $WG0_DPINGER_OPTS -p /run/dpinger $WG0_GATEWAY \
        | awk '{print $1,"-",$2,"-",$3/1000,"ms","+/-",$4/1000,"ms" }'
    else
      _warn "Wireguard configuration not found!"
    fi
}

if [ "${WG0_DISABLED}" != "yes" ] ; then
    start_wgpinger
fi
