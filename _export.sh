#!/bin/sh

set -e

ARTIFACT_DIR=$1
VERSION=$2
COMBINED_VERSION=$3

TOOLS="nvidia-debugdump nvidia-cuda-mps-control nvidia-xconfig nvidia-modprobe nvidia-smi nvidia-cuda-mps-server
nvidia-persistenced nvidia-settings"

# Removing conflicting version of libEGL
# Otherwise, ldconfig complains that libEGL.so.1 is not a symlink
if [ -f ${ARTIFACT_DIR}/libEGL.so.1 ]; then
    rm ${ARTIFACT_DIR}/libEGL.so.1
fi

# Create archives with no paths
tar -C ${ARTIFACT_DIR} -cvj $(basename -a ${ARTIFACT_DIR}/*.so.*) > libraries-${VERSION}.tar.bz2
tar -C ${ARTIFACT_DIR} -cvj ${TOOLS} > tools-${VERSION}.tar.bz2
tar -C ${ARTIFACT_DIR}/kernel -cvj $(basename -a ${ARTIFACT_DIR}/kernel/*.ko) > modules-${COMBINED_VERSION}.tar.bz2

# Package all archives
tar -cvj $(basename -a *.tar.bz2) > drivers-${COMBINED_VERSION}.tar.bz2