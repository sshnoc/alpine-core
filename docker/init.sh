#!/usr/bin/env sh

source /common.sh

SERVICES=${SERVICES:-crond}

(IFS=','; for service in $SERVICES; do
    _info "Starting service $service"
    supervisorctl start $service
    sleep 1
done)
