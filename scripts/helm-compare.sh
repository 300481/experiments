#!/usr/bin/env bash

# This script will template the manifests for the
# given Helm Chart Versions to be able to compare them.

: ${HELM_VERSION:=3.8.2}
: ${HELM_CONTAINER:=docker.io/alpine/helm}

usage()
{
  echo "Usage: $0 -u [ REPO_URL ] -c [ CHART ] -o [ OLD_VERSION ] -n [ NEW_VERSION ] -v [VALUE_FILE]"
  exit 2
}

set_variable()
{
  local varname=$1
  shift
  if [ -z "${!varname}" ]; then
    eval "$varname=\"$@\""
  else
    echo "Error: $varname already set"
    usage
  fi
}

#########################
# Main script starts here

unset REPO_URL CHART OLD_VERSION NEW_VERSION VALUE_FILE

while getopts 'u:c:o:n:v:' opt
do
  case $opt in
    u) set_variable REPO_URL $OPTARG ;;
    c) set_variable CHART $OPTARG ;;
    o) set_variable OLD_VERSION $OPTARG ;; 
    n) set_variable NEW_VERSION $OPTARG ;;
    v) set_variable VALUE_FILE $OPTARG ;;
  esac
done

[ -z "$REPO_URL" ] || [ -z "$CHART" ] || [ -z "$OLD_VERSION" ] || [ -z "$NEW_VERSION" ] || [ -z "$VALUE_FILE" ] && usage

export HELM_HOME=$(mktemp -d)

helm_container(){
    podman run -it --rm \
    -e HOME=${HELM_HOME} \
    -v ${HELM_HOME}:${HELM_HOME}:Z \
    -v $PWD:$PWD:Z \
    -w $PWD \
    $HELM_CONTAINER:$HELM_VERSION \
    $@
}

helm_container repo add chart-repo ${REPO_URL}
helm_container repo update
helm_container template chart chart-repo/${CHART} --values ${VALUE_FILE} --version ${OLD_VERSION} > ${CHART}-${OLD_VERSION}.yaml
helm_container template chart chart-repo/${CHART} --values ${VALUE_FILE} --version ${NEW_VERSION} > ${CHART}-${NEW_VERSION}.yaml
