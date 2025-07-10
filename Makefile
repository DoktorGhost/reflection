LOCAL_BIN := $(shell pwd)/bin

install-go-deps:
	GOBIN=$(LOCAL_BIN) go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.34.1
	GOBIN=$(LOCAL_BIN) go install -mod=mod google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.4.0
	GOBIN=$(LOCAL_BIN) go install github.com/bufbuild/buf/cmd/buf@v1.50.0
	GOBIN=$(LOCAL_BIN) go install github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc@v1.5.1

generate: install-go-deps
	GOBIN=$(LOCAL_BIN) buf generate

proto: generate-go-common-v1-api generate-go-combo_service_v1-api

generate-go-common-v1-api:
	mkdir -p src/go/pkg/grpc/common/v1
	GOBIN=$(LOCAL_BIN) protoc \
    	--proto_path api/grpc/protobuf/common/v1 \
    	--go_out=src/go/pkg/grpc/common/v1 \
    	--go_opt=paths=source_relative \
    	--go-grpc_out=src/go/pkg/grpc/common/v1 \
    	--go-grpc_opt=paths=source_relative \
    	--plugin=protoc-gen-go=bin/protoc-gen-go \
    	--plugin=protoc-gen-go-grpc=bin/protoc-gen-go-grpc \
    	--plugin=protoc-gen-doc=bin/protoc-gen-doc \
    	--doc_out=api/grpc/protobuf/common/v1 \
    	--doc_opt=markdown,README.md,source_relative \
    	api/grpc/protobuf/common/v1/*.proto

generate-go-combo_service_v1-api:
	mkdir -p src/go/pkg/grpc/combo_service
	GOBIN=$(LOCAL_BIN) protoc \
	--proto_path . \
	--proto_path api/grpc/protobuf/combo_service_v1 \
	--go_out=src/go/pkg/grpc/combo_service \
	--go_opt=paths=source_relative \
	--go-grpc_out=src/go/pkg/grpc/combo_service \
	--go-grpc_opt=paths=source_relative \
	--plugin=protoc-gen-go=bin/protoc-gen-go \
	--plugin=protoc-gen-go-grpc=bin/protoc-gen-go-grpc \
	--plugin=protoc-gen-doc=bin/protoc-gen-doc \
	--doc_out=. \
	--doc_opt=markdown,README.md,source_relative \
	api/grpc/protobuf/combo_service_v1/*.proto