# TODO list

## Open

* Automatic K3S update [K3S documentation](https://rancher.com/docs/k3s/latest/en/upgrades/automated/) Issue #5 [Link](https://github.com/300481/experiments/issues/5)

## Closed

* Let SSH run under different port [example implementation](https://gist.github.com/icedream/75135f63f433ec52d652c7245dd17e30) Issue #1 [Link](https://github.com/300481/experiments/issues/1)
* encrypted filesystem with remote key Issue #3 [Link](https://github.com/300481/experiments/issues/3)
  * [example documentation](https://coreos.github.io/butane/examples/#luks-encrypted-storage)
  * [Butane config documentation](https://coreos.github.io/butane/config-fcos-v1_3/)
  * [Fedora CoreOS documentation](https://docs.fedoraproject.org/en-US/fedora-coreos/storage/#_encrypted_storage_luks)
* Configure Zincati Wariness and update windows Issue #6 [Link](https://github.com/300481/experiments/issues/6)
* Prepare and install K3S installation [example implementation](https://www.murillodigital.com/tech_talk/k3s_in_coreos/) Issue #2 [Link](https://github.com/300481/experiments/issues/2)

# Ignition creation

```bash
alias butane='podman run --rm --tty --interactive \
              --security-opt label=disable        \
              --volume ${PWD}:/pwd --workdir /pwd \
              quay.io/coreos/butane:release'
butane --pretty --strict fcos.bu > fcos.ign
```
