# Stage 1: Builder
FROM golang:latest AS builder

# Set working directory
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN go build -o main .

FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y git ca-certificates tzdata && \
    apt-get clean && \
    update-ca-certificates

# Menentukan direktori kerja dalam container
WORKDIR /app

# Menyalin binary dari tahap builder
COPY --from=builder /app/main ./main
# COPY --from=builder /app/migrate ./migrate

# Menentukan port yang akan di-expose
EXPOSE 8080

# Menjalankan aplikasi
CMD ["./main"]