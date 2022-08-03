# adapt buildah containerfile to use openSUSE Tumbleweed as base
# stable/Containerfile
#
# This image can be used to create a secured container
# that runs safely with privileges within the container.
#
FROM registry.opensuse.org/opensuse/tumbleweed:latest

# Don't include container-selinux and remove
# directories used by dnf that are just taking
# up space.
RUN set -euo pipefail; zypper -n in shadow buildah fuse-overlayfs cpp ; zypper -n clean; rm -rf /var/log/* ; useradd build

ADD containers.conf /etc/containers/

# Copy & modify the defaults to provide reference if runtime changes needed.
# Changes here are required for running with fuse-overlay storage inside container.
RUN sed -i -e 's|^#mount_program|mount_program|g' \
           -e '/additionalimage.*/a "/var/lib/shared",' \
           -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' \
           /etc/containers/storage.conf

RUN mkdir -p /var/lib/shared/overlay-images \
             /var/lib/shared/overlay-layers \
             /var/lib/shared/vfs-images \
             /var/lib/shared/vfs-layers && \
    touch /var/lib/shared/overlay-images/images.lock && \
    touch /var/lib/shared/overlay-layers/layers.lock && \
    touch /var/lib/shared/vfs-images/images.lock && \
    touch /var/lib/shared/vfs-layers/layers.lock

# Define uid/gid ranges for our user https://github.com/containers/buildah/issues/3053
RUN echo -e "build:1:999\nbuild:1001:64535" > /etc/subuid; \
 echo -e "build:1:999\nbuild:1001:64535" > /etc/subgid; \
 mkdir -p /home/build/.local/share/containers; \
 chown -R build:build /home/build

VOLUME /var/lib/containers
VOLUME /home/build/.local/share/containers

# Set an environment variable to default to chroot isolation for RUN
# instructions and "buildah run".
ENV BUILDAH_ISOLATION=chroot
