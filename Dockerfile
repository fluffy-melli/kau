FROM alpine:latest

ARG version="0.17.0-dev.263+0add2dfc4"

RUN apk add --no-cache \
    build-base \
    tar \
    xz \
    curl

WORKDIR /opt

RUN curl -L "https://ziglang.org/builds/zig-x86_64-linux-${version}.tar.xz" -o zig.tar.xz && \
    tar -xf zig.tar.xz && \
    rm zig.tar.xz

RUN ln -s /opt/zig-* /opt/zig

ENV PATH="/opt/zig:$PATH"

WORKDIR /app