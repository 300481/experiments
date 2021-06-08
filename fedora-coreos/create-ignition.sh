#!/bin/bash
podman run --rm --tty --interactive \
    --security-opt label=disable        \
    --volume ${PWD}:/pwd --workdir /pwd \
    quay.io/coreos/butane:release \
    --pretty --strict fcos.bu > fcos.ign