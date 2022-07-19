#!/usr/bin/env bash

# This script will template the manifests for the
# given Helm Chart with dofferent values to be able to compare them.

: ${HELM_VERSION:=3.8.2}
: ${HELM_CONTAINER:=docker.io/alpine/helm}

usage()
{
  echo "Usage: $0 -u [ REPO_URL ] -c [ CHART ] -v [ VERSION ] -a [ A_VALUES ] -b [ B_VALUES ]"
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

unset REPO_URL CHART VERSION A_VALUES B_VALUES

while getopts 'u:c:v:a:b:' opt
do
  case $opt in
    u) set_variable REPO_URL $OPTARG ;;
    c) set_variable CHART $OPTARG ;;
    v) set_variable VERSION $OPTARG ;;
    a) set_variable A_VALUES $OPTARG ;; 
    b) set_variable B_VALUES $OPTARG ;;
  esac
done

[ -z "$REPO_URL" ] || [ -z "$CHART" ] || [ -z "$VERSION" ] || [ -z "$A_VALUES" ] || [ -z "$B_VALUES" ] && usage

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
helm_container template chart chart-repo/${CHART} --values ${A_VALUES} --version ${VERSION} > ${CHART}-A.yaml
helm_container template chart chart-repo/${CHART} --values ${B_VALUES} --version ${VERSION} > ${CHART}-B.yaml
