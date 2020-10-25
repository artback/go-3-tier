# Start from the latest golang base image
FROM golang:alpine as builder

# Add Maintainer Info
LABEL maintainer="Jonatan artback <artback@protonmail.com>"

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependancies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main ./cmd/main.go


######## Start a new stage from scratch #######
# This assure that the deployed image only contains what is neccesary for running the golang binary.
FROM alpine:latest

WORKDIR /app
## copy the binary from the builder image
COPY --from=builder /app/main .
## run the golang binary
CMD ["./main"]
