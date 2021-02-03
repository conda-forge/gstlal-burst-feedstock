#!/bin/bash

set -ex

mkdir -p _build
pushd _build

# only link libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"
export GSTLAL_LIBS="-L${PREFIX}/lib -lgstlal -lgstlaltags -lgstlaltypes"
export gstreamer_LIBS="-L${PREFIX}/lib -lgstbase-1.0 -lgstreamer-1.0"
export gstreamer_audio_LIBS="-L${PREFIX}/lib -lgstaudio-1.0"
export LAL_LIBS="-L${PREFIX}/lib -llal -llalmetaio"

# configure
${SRC_DIR}/configure \
  --enable-introspection=yes \
  --prefix=${PREFIX} \
;

# build
make -j ${CPU_COUNT} V=1 VERBOSE=1

# install
make -j ${CPU_COUNT} V=1 VERBOSE=1 install

# test
make -j ${CPU_COUNT} V=1 VERBOSE=1 check
