#!/bin/sh

set  -eu

. ./make.config

if [ ! -d "${BSEC_DIR}" ]; then
  echo 'BSEC directory missing.'
  exit 1
fi

echo 'Patching...'
dir="${BSEC_DIR}/examples"
patch='patches/eCO2+bVOCe.diff'
if patch -N --dry-run --silent -d "${dir}/" \
  < "${patch}" 2>/dev/null
then
  patch -d "${dir}/" < "${patch}"
else
  echo 'Already applied.'
fi

echo 'Compiling...'
cc -Wall -Wno-unused-but-set-variable -Wno-unused-variable -static \
  -std=c99 -pedantic \
  -iquote"${BSEC_DIR}"/API \
  -iquote"${BSEC_DIR}"/algo/bin/${ARCH} \
  -iquote"${BSEC_DIR}"/examples \
  "${BSEC_DIR}"/API/bme680.c \
  "${BSEC_DIR}"/examples/bsec_integration.c \
  ./bsec_bme680.c \
  -L"${BSEC_DIR}"/algo/bin/"${ARCH}" -lalgobsec \
  -lm -lrt \
  -o bsec_bme680
echo 'Compiled.'

cp "${BSEC_DIR}"/config/"${CONFIG}"/bsec_iaq.config ./	
echo 'Copied config.'
