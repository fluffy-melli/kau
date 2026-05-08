FROM debian:stable-slim

ARG ZIG_VERSION=0.17.0-dev.263+0add2dfc4

RUN apt-get update && apt-get install -y \
    curl \
    xz-utils \
    build-essential \
    pkg-config \
    libgl1-mesa-dev \
    libx11-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxi-dev \
    libxcursor-dev \
    libwayland-dev \
    libxkbcommon-dev \
    libasound2-dev

WORKDIR /opt

RUN curl -L \
    "https://ziglang.org/builds/zig-x86_64-linux-${ZIG_VERSION}.tar.xz" \
    -o zig.tar.xz && \
    tar -xf zig.tar.xz && \
    rm zig.tar.xz

ENV PATH="/opt/zig-x86_64-linux-${ZIG_VERSION}:$PATH"

WORKDIR /app