FROM golang:1.24.5-alpine3.22 AS build

WORKDIR /app

COPY . .

RUN go mod download

RUN go build -o simple-web-app

FROM alpine:latest

WORKDIR /app

COPY --from=build /app/simple-web-app simple-web-app

EXPOSE 8080

ENTRYPOINT ["/app/simple-web-app"]
