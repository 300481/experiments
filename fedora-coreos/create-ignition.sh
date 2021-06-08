#!/bin/bash
alias butane='podman run --rm --tty --interactive \
              --security-opt label=disable        \
              --volume ${PWD}:/pwd --workdir /pwd \
              quay.io/coreos/butane:release'

butane --pretty --strict fcos.bu > fcos.ign