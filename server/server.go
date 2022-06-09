package main

import (
	"context"
	"log"
	"net"
	"time"

	"github.com/lightstep/otel-launcher-go/launcher"
	"go.opentelemetry.io/contrib/instrumentation/google.golang.org/grpc/otelgrpc"
	"go.opentelemetry.io/otel"
	"google.golang.org/grpc"

	"otel/grpc/api"
)

const (
	addr              = ":9999"
	exporterAddr      = "localhost:8360"
	tracerServiceName = "test-otel"
)

var tracer = otel.Tracer("server")

type helloServer struct {
	api.HelloServiceServer
}

func getOutboundIP(ctx context.Context) (string, error) {

	_, span := tracer.Start(ctx, "getOutboundIP")
	defer span.End()

	conn, err := net.Dial("udp", "8.8.8.8:80")
	if err != nil {
		return "", err
	}
	defer func() { _ = conn.Close() }()
	localAddr := conn.LocalAddr().(*net.UDPAddr)

	time.Sleep(134 * time.Millisecond)
	return localAddr.IP.String(), nil
}

func (s *helloServer) SayHello(ctx context.Context, in *api.HelloRequest) (*api.HelloResponse, error) {

	ctx, span := tracer.Start(ctx, "SayHello")
	defer span.End()

	time.Sleep(50 * time.Millisecond)

	ip, _ := getOutboundIP(ctx)
	return &api.HelloResponse{Reply: "Hello " + in.Greeting + " from " + ip}, nil
}

func main() {

	otelLauncher := launcher.ConfigureOpentelemetry(
		launcher.WithServiceName(tracerServiceName),
		launcher.WithSpanExporterEndpoint(exporterAddr),
		launcher.WithSpanExporterInsecure(true),
		launcher.WithMetricsEnabled(false),
		launcher.WithMetricExporterEndpoint(exporterAddr),
	)
	defer otelLauncher.Shutdown()

	log.Println("serving on", addr)

	ln, err := net.Listen("tcp", addr)
	if err != nil {
		log.Fatal(err)
		return
	}

	server := grpc.NewServer(
		grpc.UnaryInterceptor(otelgrpc.UnaryServerInterceptor()),
		grpc.StreamInterceptor(otelgrpc.StreamServerInterceptor()),
	)

	api.RegisterHelloServiceServer(server, &helloServer{})
	if err := server.Serve(ln); err != nil {
		log.Fatal(err)
		return
	}
}
