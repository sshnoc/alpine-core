function _log () {
    local _type=${1:INFO}
    shift

    local prefix=" "
    if [ -n "$LOG_PREFIX" ] ; then
      prefix="[${LOG_PREFIX}] "
    fi
    echo "$(date '+%Y-%m-%d %H:%M:%S')     ${_type} ${prefix}$*"
}
function _warn() {
    _log "WARN" "$*"
}

function _info() {
    _log "INFO" "$*"
}

function _error() {
    _log "ERROR" "$*"
}

function _die() {
    _error "$1"
    kill -SIGQUIT 1
    exit
}
