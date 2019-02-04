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

info "Testing ${tag}:${version}"

testUser() {
    local hmctsUser
    local whoami

    hmctsUser="hmcts"
    whoami=$(echo `docker run ${tag}:${version} id -u ${hmctsUser}` | removeTrailingspaces)

    if [[ "$whoami" != "1001" ]]; then
        fatal "User $hmctsUser not found."
    else
        info "OK User $hmctsUser found"
    fi
}

testWorkdir() {
    local defaultWorkdir
    local workDir

    defaultWorkdir="/opt/app"
    workDir=$(echo `docker run ${tag}:${version} pwd` | removeTrailingspaces)

    if [[ "$workDir" != "$defaultWorkdir" ]]; then
        fatal "Workdir is not $defaultWorkdir. Workdir found: $workDir"
    else
        info "OK Workdir is $defaultWorkdir"
    fi
}

testDefaultCmd() {
    local defaultCmd
    local cmd

    defaultCmd="[\"yarn\",\"start\"]"
    cmd=$(echo `docker inspect --format='{{json .Config.Cmd}}' ${tag}:${version}`)
    
    if [[ "$cmd" != "$defaultCmd" ]]; then
        fatal "Default CMD is not $defaultCmd. Default CMD found: $cmd"
    else
        info "OK Default CMD is $defaultCmd"
    fi
}

testUser
testWorkdir
testDefaultCmd