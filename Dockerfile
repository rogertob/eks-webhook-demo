# Build stage
FROM golang:1.24-alpine AS builder
WORKDIR /app
# Copy go.mod and go.sum first for dependency caching
COPY go.mod go.sum ./
RUN go mod download
# Copy the rest of the application code
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o webhook

# Final stage
FROM alpine:3.17
RUN apk add --no-cache busybox-extras file
# Expose the port the app listens on
EXPOSE 8443
WORKDIR /usr/local/bin
COPY --from=builder /app/webhook .
RUN chmod 755 webhook

# Ensure the binary is in the PATH
ENV PATH="/usr/local/bin:${PATH}"

# Set working directory for certificate access (ensure this matches your cert mount)
WORKDIR /etc/webhook
CMD ["webhook"]
