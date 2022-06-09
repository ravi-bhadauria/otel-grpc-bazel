#!/usr/bin/env bash

# This script creates new BUILD.bazel files or update existing BUILD.bazel
# files automatically for Go and Protobufs using Gazelle

set -eu -o pipefail

BAZEL=/usr/local/bin/bazel
# use gogoprotobuf which is performance optimized
# e.g. gogoprotobuf uses code generation instead of reflection for fast marshalling/unmarshalling

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
REPO_ROOT_DIR=$(cd "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd)

usage() {
    echo "Usage: $0 [-f|--fix]" 1>&2
    exit 1
}

DO_FIX="FALSE"
for arg in "$@"; do
    case $arg in
    -f | --fix) DO_FIX="TRUE" ;;
    -h | *) usage ;;
    esac
done

cd "${REPO_ROOT_DIR}"

if [ "${DO_FIX}" == "TRUE" ]; then
    echo -ne "\033[0;32m"
    echo 'Fixing go build files. This is potentially a breaking operation...'
    echo -ne "\033[0m"
    $BAZEL run //:gazelle -- fix
else
    echo -ne "\033[0;32m"
    echo 'Updating go build files...'
    echo -ne "\033[0m"
    $BAZEL run //:gazelle -- update
fi

exit 0
