FROM golang:1.25-alpine AS builder

WORKDIR /app
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o server

FROM scratch

WORKDIR /app
COPY --from=builder /app/server .

EXPOSE 3001

CMD ["./server"]