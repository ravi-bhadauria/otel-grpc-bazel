###################################
# Setup
###################################

workspace(name = "com_etsy_lightstep_demo")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

rules_go_version = "0.31.0"

rules_go_sha256 = "f2dcd210c7095febe54b804bb1cd3a58fe8435a909db2ec04e31542631cf715c"

gazelle_version = "0.24.0"

gazelle_sha256 = "de69a09dc70417580aabf20a28619bb3ef60d038470c7cf8442fafcf627c21cb"

go_version = "1.18.1"

rules_docker_version = "0.17.0"

rules_docker_sha256 = "59d5b42ac315e7eadffa944e86e90c2990110a1c8075f1cd145f487e999d22b3"

rules_proto_grpc_version = "4.0.1"

rules_proto_grpc_sha256 = "28724736b7ff49a48cb4b2b8cfa373f89edfcb9e8e492a8d5ab60aa3459314c8"

# Golang support
http_archive(
    name = "rules_proto_grpc",
    sha256 = rules_proto_grpc_sha256,
    strip_prefix = "rules_proto_grpc-{}".format(rules_proto_grpc_version),
    urls = ["https://github.com/rules-proto-grpc/rules_proto_grpc/archive/{}.tar.gz".format(rules_proto_grpc_version)],
)

http_archive(
    name = "bazel_gazelle",
    sha256 = gazelle_sha256,
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/bazel-gazelle/releases/download/v{}/bazel-gazelle-v{}.tar.gz".format(gazelle_version, gazelle_version),
        "https://github.com/bazelbuild/bazel-gazelle/releases/download/v{}/bazel-gazelle-v{}.tar.gz".format(gazelle_version, gazelle_version),
    ],
)

http_archive(
    name = "io_bazel_rules_go",
    sha256 = rules_go_sha256,
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v{}/rules_go-v{}.zip".format(rules_go_version, rules_go_version),
        "https://github.com/bazelbuild/rules_go/releases/download/v{}/rules_go-v{}.zip".format(rules_go_version, rules_go_version),
    ],
)

# gazelle:repo bazel_gazelle
load("@rules_proto_grpc//:repositories.bzl", "bazel_gazelle", "io_bazel_rules_go")

io_bazel_rules_go()

load("@io_bazel_rules_go//go:deps.bzl", "go_register_toolchains", "go_rules_dependencies")

go_rules_dependencies()

go_register_toolchains(version = go_version)

# needed for gRPC support
load("@rules_proto_grpc//go:repositories.bzl", rules_proto_grpc_go_repos = "go_repos")

rules_proto_grpc_go_repos()

# Load third party dependencies
load("//3rdparty:go_workspace.bzl", "go_dependencies")

# Following comments tells Gazelle's where to edit this file hence do not edit!
# gazelle:repo bazel_gazelle
# gazelle:repository_macro 3rdparty/go_workspace.bzl%go_dependencies
go_dependencies()

bazel_gazelle()

load("@bazel_gazelle//:deps.bzl", "gazelle_dependencies")

gazelle_dependencies()

# Rules docker
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = rules_docker_sha256,
    strip_prefix = "rules_docker-{}".format(rules_docker_version),
    urls = [
        "https://github.com/bazelbuild/rules_docker/releases/download/v{}/rules_docker-v{}.tar.gz".format(rules_docker_version, rules_docker_version),
    ],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

load(
    "@io_bazel_rules_docker//go:image.bzl",
    _go_image_repos = "repositories",
)

_go_image_repos()
