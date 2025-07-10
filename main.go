package main

import (
	"context"
	v1 "github.com/DoktorGhost/reflection/src/go/pkg/grpc/data/v1"
	"github.com/DoktorGhost/reflection/src/go/pkg/grpc/service_1/api/grpc/protobuf/service_1"

	"log"
	"net"

	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

type oneServiceServer struct {
	service_1.UnimplementedOneServiceServer
}
type twoServiceServer struct {
	service_1.UnimplementedTwoServiceServer
}

type threeServiceServer struct {
	service_1.UnimplementedThreeServiceServer
}

func (s *oneServiceServer) GetOther(_ context.Context, _ *v1.DataOneRequest) (*v1.DataOneResponse, error) {
	return &v1.DataOneResponse{}, nil
}

func (s *twoServiceServer) GetOther(_ context.Context, _ *v1.DataTwoRequest) (*v1.DataTwoResponse, error) {
	return &v1.DataTwoResponse{}, nil
}

func (s *threeServiceServer) GetOther(_ context.Context, _ *v1.DataThreeRequest) (*v1.DataThreeResponse, error) {
	return &v1.DataThreeResponse{}, nil
}

func main() {
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer()

	service_1.RegisterOneServiceServer(grpcServer, &oneServiceServer{})
	service_1.RegisterTwoServiceServer(grpcServer, &twoServiceServer{})
	service_1.RegisterThreeServiceServer(grpcServer, &threeServiceServer{})

	reflection.Register(grpcServer)

	log.Println("gRPC server listening on :50051")
	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v", err)
	}
}
