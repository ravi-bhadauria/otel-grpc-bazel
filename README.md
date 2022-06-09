# gRPC OpenTelemetry instrumentation example with Lightstep in Bazel

[![PkgGoDev](https://pkg.go.dev/badge/go.opentelemetry.io/contrib/instrumentation/google.golang.org/grpc/otelgrpc)](https://pkg.go.dev/go.opentelemetry.io/contrib/instrumentation/google.golang.org/grpc/otelgrpc)


You can run this example with bazel. First start the developer satellite by using [this link](https://docs.lightstep.com/docs/use-developer-mode-to-quickly-see-traces#start-the-developer-satellite).

**LightStep** exporter:

Start the server:

```shell
bazel run //server
```

Start the client:

```shell
bazel run //client
```

## Links

- [OpenTelemetry Go instrumentations](https://opentelemetry.uptrace.dev/instrumentations/?lang=go)
- [OpenTelemetry Tracing API](https://opentelemetry.uptrace.dev/guide/go-tracing.html)
