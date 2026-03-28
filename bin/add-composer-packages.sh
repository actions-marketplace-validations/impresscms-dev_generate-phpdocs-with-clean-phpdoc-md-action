#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

COMPOSER_MAJOR=$(
  composer --version 2>/dev/null | sed -nE 's/.* ([0-9]+)\..*/\1/p' | head -n 1
)

# Composer v1 does not support --ignore-platform-req=..., only --ignore-platform-reqs.
# To avoid pulling PHP-incompatible packages, skip platform ignore flags on Composer v1.
PLATFORM_FLAGS=""
if [ "$COMPOSER_MAJOR" != "1" ]; then
  PLATFORM_FLAGS="--ignore-platform-req=ext-* --ignore-platform-req=lib-*"
fi

CURRENT_CMD=$(
cat <<EOF
  composer require \
    $("$SCRIPT_DIR"/get-composer-dependencies.php) \
    --no-plugins \
    $PLATFORM_FLAGS \
    --no-scripts \
    --working-dir=$COPY_DATA_PATH
EOF
);

$CURRENT_CMD
