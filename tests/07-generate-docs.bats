#!/usr/bin/env bats

setup_file() {
    export DOCS_PATH=$(mktemp -d)
    export COPY_DATA_PATH=$(mktemp -d)
    export TMP_DATA_PATH=$(mktemp -d)
    export PHPDOCMD_FILE=$COPY_DATA_PATH/.phpdoc-md
    export CLASS_ROOT_NAMESPACE="Imponeer\\"
    export PHP_CLASSES_FILTERED_FILE=$TMP_DATA_PATH/classes.lst

    cat > "$PHP_CLASSES_FILTERED_FILE" <<EOL
Imponeer\\ToArrayInterface
EOL

    pushd "$COPY_DATA_PATH"
        git clone --branch v2.0.7 --depth 1 --quiet https://github.com/imponeer/toarray-interface.git .
    popd

    $BATS_TEST_DIRNAME/../bin/generate-config.php \
        "$PHPDOCMD_FILE" \
        "$PHP_CLASSES_FILTERED_FILE" \
        "$CLASS_ROOT_NAMESPACE" \
        "$DOCS_PATH"

    $BATS_TEST_DIRNAME/../bin/add-composer-packages.sh
}

tear_file() {
    rm -rf "$DOCS_PATH" || true
    rm -rf "$COPY_DATA_PATH" || true
    rm -rf "$TMP_DATA_PATH" || true
}

@test "Generating doesn't exists with non zero code" {
    $BATS_TEST_DIRNAME/../bin/generate-docs.sh
}

@test "Generating produced some files" {
    [ -s "$DOCS_PATH" ]
}
