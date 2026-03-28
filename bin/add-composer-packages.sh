#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Ignore extension/library platform checks to avoid host project ext mismatches,
# while keeping PHP version constraints enforced.
CURRENT_CMD=$(
cat <<EOF
  composer require \
    $("$SCRIPT_DIR"/get-composer-dependencies.php) \
    --no-plugins \
    --ignore-platform-req=ext-* \
    --ignore-platform-req=lib-* \
    --no-scripts \
    --working-dir=$COPY_DATA_PATH
EOF
);

$CURRENT_CMD
