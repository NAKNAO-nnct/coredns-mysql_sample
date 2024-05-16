FROM golang:alpine AS builder

# CoreDNS version
ARG COREDNS_VERSION="1.11.3"

RUN apk add --no-cache git make gcc musl-dev bash curl

RUN git clone --branch "v${COREDNS_VERSION}" --depth 1 https://github.com/coredns/coredns.git /coredns && \
    cd /coredns && \
    echo "mysql:github.com/cloud66-oss/coredns_mysql" >> plugin.cfg && \
    make

FROM alpine:latest

COPY --from=builder /coredns/coredns /coredns

COPY ./Corefile /etc/coredns/Corefile

EXPOSE 53 53/udp

WORKDIR /etc/coredns

CMD ["/coredns", "-conf", "/etc/coredns/Corefile"]
