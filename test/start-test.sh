#!/bin/bash

BASE_DIR="`dirname $0`"
COVERAGE=0

command=""
if [ "$COVERAGE" -eq "1" ]; then
    echo "Test coverage";
    command="$BASE_DIR/bin/bashcov/bin/bashcov ";
fi

$command $BASE_DIR/tests/userTest.sh

