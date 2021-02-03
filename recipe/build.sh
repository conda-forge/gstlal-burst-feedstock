#!/bin/bash

set -ex

mkdir -p _build
pushd _build

# only link libraries we actually use
export GSL_LIBS="-L${PREFIX}/lib -lgsl"
export GSTLAL_LIBS="-L${PREFIX}/lib -lgstlal -lgstlaltags -lgstlaltypes"
export gstreamer_audio_LIBS="-L${PREFIX}/lib -lgstaudio-1.0"
export LAL_LIBS="-L${PREFIX}/lib -llal -llalmetaio"

# replace '/usr/bin/env python3' with '/usr/bin/python'
# so that conda-build will then replace it with the $PREFIX/bin/python
sed -i.tmp 's/\/usr\/bin\/env python3/\/usr\/bin\/python/g' ${SRC_DIR}/bin/gstlal_*

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
