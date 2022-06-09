#!/usr/bin/env bash

# This script bazelifies dependencies for Go and JVM (Scala)
# For JVM we use https://github.com/johnynek/bazel-deps to generate the dependencies.
# For GO we use gazelle.

set -eu -o pipefail

BAZEL=/usr/local/bin/bazel

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
REPO_ROOT_DIR=$(cd "${SCRIPT_DIR}/.." >/dev/null 2>&1 && pwd)

bazelify_go_dependencies() {
    echo -ne "\033[0;32m"
    echo 'Bazelifying Go dependencies using go/go.mod as source...'
    echo -ne "\033[0m"

    cd "$REPO_ROOT_DIR"
    $BAZEL run //:gazelle -- update-repos -from_file=go.mod -to_macro=3rdparty/go_workspace.bzl%go_dependencies -prune=true
}

usage() {
    echo "Usage: $0 [-g|--go]" 1>&2
    exit 1
}

if [[ $# -eq 0 ]]; then
    usage
fi

for arg in "$@"; do
    case $arg in
    -g | --go) bazelify_go_dependencies ;;
    -h | *) usage ;;
    esac
done

exit 0
