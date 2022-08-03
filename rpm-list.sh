#!/bin/sh -ue
container=$(buildah from $1)
mount=$(buildah mount ${container})

rpm --root ${mount} -qa
