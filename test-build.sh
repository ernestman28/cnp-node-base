#!/usr/bin/env bash
#
# Run a test build for a given image.
# 
# Sample usage:
# 
# $ ./test-build.sh <image tag> <image version>
#


set -euo pipefail

info() {
  printf "%s\\n" "$@"
}

fatal() {
  printf "/!\ Fatal Error: %s\\n" "$@"
  exit 1
}

removeTrailingspaces () {
    sed -e 's/[[:space:]]*$//' "$@"
}

tag=${1}
version=${2-latest}

testUser() {

    local whoami
    local defaultUser

    info "Testing ${tag}:${version}"

    defaultUser="hmcts"
    whoami=$(echo `docker run -it ${tag}:${version} whoami` | removeTrailingspaces)

    if [ $whoami != $defaultUser ]; then
        fatal "User is not $defaultUser. User found: $whoami"
    else
        info "OK User is $defaultUser"
    fi
}

testUser
