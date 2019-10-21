#!/bin/sh
NEXUS_USER="${NEXUS_USER:-bcandrze-admin}"
if [ -z "$NEXUS_PASS" ]; then
    echo "Enter ${NEXUS_USER} Password:"; read NEXUS_PASS
else
    echo "Nexus Password loaded from NEXUS_PASS env var"
fi

NEXUS_SERVER="https://nexus...../nexus/repository"
NEXUS_REPO="${NEXUS_REPO:-ISD-binaries}"

BIN_FILE=$1
BIN_FILENAME="${BIN_FILENAME:-$(basename $1)}"
#echo "Filename=${BIN_FILENAME}"
BIN_GROUP="${BIN_GROUP:-fortify}"
BIN_VERSION="${BIN_VERSION:-17.1}"

echo "curl --fail -k -u ${NEXUS_USER}:********* --upload-file ${BIN_FILE} ${NEXUS_SERVER}/${NEXUS_REPO}/${BIN_GROUP}/${BIN_FILENAME}"

curl --fail -k -u ${NEXUS_USER}:${NEXUS_PASS} --upload-file ${BIN_FILE} ${NEXUS_SERVER}/${NEXUS_REPO}/${BIN_GROUP}/${BIN_FILENAME}