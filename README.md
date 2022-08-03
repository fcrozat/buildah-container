# Buildah Container #

This is a port of upstream Buildah container ( https://github.com/containers/buildah/tree/main/contrib/buildahimage/stable )
using openSUSE packages as base.

## Example to use this container

### list all packages from a container

podman build -t buildah-tw .

to list all packages from bci-init container:
podman run -ti --net=host --security-opt label=disable --security-opt seccomp=unconfined --device /dev/fuse:rw -v $PWD/rpm-list.sh:/rpm-list.sh localhost/buildah-tw buildah unshare sh -x /rpm-list.sh registry.opensuse.org/bci/bci-init


