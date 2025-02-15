# Build the manager binary
FROM docker.io/library/golang:1.20.5 as builder

WORKDIR /workspace
# Copy the Go Modules manifests
COPY go.mod go.mod
COPY go.sum go.sum
COPY scripts/aws_sdk_model_override/aws-sdk-go/go.mod scripts/aws_sdk_model_override/aws-sdk-go/go.mod
COPY scripts/aws_sdk_model_override/aws-sdk-go/go.sum scripts/aws_sdk_model_override/aws-sdk-go/go.sum


# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate our downloaded layer
#RUN go mod download
RUN GOPROXY=direct go mod download

# Copy the go source
COPY main.go main.go
COPY pkg/ pkg/
COPY controllers/ controllers/
COPY scripts scripts

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o manager main.go

# Use distroless as minimal base image to package the manager binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /workspace/manager .
USER 65532:65532

ENTRYPOINT ["/manager"]
