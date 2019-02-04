#!/usr/bin/env bash
#
# Run a test build for all images.

set -euo pipefail

info() {
  printf "%s\\n" "$@"
}

fatal() {
  printf "/!\ Fatal Error: %s\\n" "$@"
  exit 1
}

tag=${1}
version=${2-latest}

test() {

    local tag
    local version
    local whoami

    tag=${1}
    version=${2}

    info "Testing ${tag}:${version}"

    whoami=$(echo `docker run -it ${tag}:${version} whoami` | sed -e 's/[[:space:]]*$//')

    if [ $whoami != "hmcts" ]; then
        fatal "User is not hmcts. User found: $whoami"
    else
        info "OK User is hmcts"
    fi
}

test ${tag} ${version}
