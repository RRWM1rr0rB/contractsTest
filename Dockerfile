FROM golang:1.22.6

RUN apt-get update && apt-get install -y protobuf-compiler \
    && go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.27.1 \
    && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1.0

WORKDIR /app

COPY . .

RUN git clone https://github.com/googleapis/googleapis.git /opt/googleapis

CMD ["protoc", "-I=proto", "-I=/opt/googleapis", "--go_out=gen/go", "--go-grpc_out=gen/go", "proto/common/filter/v1/*.proto", "proto/order_service/v1/*.proto"]
