function _log () {
    local _type=${1:INFO}
    shift
    echo "$(date '+%Y-%m-%d %H:%M:%S')     ${_type} init.sh: $*"
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
