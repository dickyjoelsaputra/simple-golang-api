FROM golang:latest AS builder

# Menyalin go.mod dan go.sum terlebih dahulu untuk caching dependensi
COPY go.mod go.sum ./

# Mengunduh dependensi
RUN go mod download

# Menyalin seluruh file proyek ke dalam container
COPY . .

# Membuild aplikasi
RUN go build -o main ./main.go


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