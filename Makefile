LOCAL_BIN := $(shell pwd)/bin

install-go-deps:
	GOBIN=$(LOCAL_BIN) go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.34.1
	GOBIN=$(LOCAL_BIN) go install -mod=mod google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.4.0
	GOBIN=$(LOCAL_BIN) go install github.com/bufbuild/buf/cmd/buf@v1.50.0
	GOBIN=$(LOCAL_BIN) go install github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc@v1.5.1

proto: generate-go-data-v1-api generate-go-service-api

generate-go-data-v1-api:
	mkdir -p src/go/pkg/grpc/data/v1
	GOBIN=$(LOCAL_BIN) protoc \
    --go_out=src/go/pkg/grpc/data/v1 \
    --go_opt=paths=source_relative \
    --go-grpc_out=src/go/pkg/grpc/data/v1 \
    --go-grpc_opt=paths=source_relative \
    --plugin=protoc-gen-go=bin/protoc-gen-go \
    --plugin=protoc-gen-go-grpc=bin/protoc-gen-go-grpc \
    --plugin=protoc-gen-doc=bin/protoc-gen-doc \
    api/grpc/protobuf/data/v1/*.proto

generate-go-service-api:
	mkdir -p src/go/pkg/grpc/service_1
	GOBIN=$(LOCAL_BIN) protoc \
	--go_out=src/go/pkg/grpc/service_1 \
	--go_opt=paths=source_relative \
	--go-grpc_out=src/go/pkg/grpc/service_1 \
	--go-grpc_opt=paths=source_relative \
	--plugin=protoc-gen-go=bin/protoc-gen-go \
	--plugin=protoc-gen-go-grpc=bin/protoc-gen-go-grpc \
	--plugin=protoc-gen-doc=bin/protoc-gen-doc \
	api/grpc/protobuf/service_1/*.proto