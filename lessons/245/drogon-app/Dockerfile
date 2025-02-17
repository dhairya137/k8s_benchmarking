FROM ubuntu:22.04 AS builder

# Install minimal build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    pkg-config \
    g++ \
    git \
    libssl-dev \
    libjsoncpp-dev \
    uuid-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Drogon Framework
WORKDIR /tmp
RUN git clone --depth 1 --branch v1.9.9 https://github.com/drogonframework/drogon && \
    cd drogon && \
    git submodule update --init && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && \
    make install && \
    ldconfig

# Build the application
WORKDIR /app
COPY . .
RUN mkdir -p build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make

# Final stage
FROM ubuntu:22.04

# Install only runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libjsoncpp25 \
    uuid \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

# Copy the built executable and necessary files
COPY --from=builder /app/build/drogon-app /app/drogon-app
COPY --from=builder /usr/local/lib/libdrogon.so* /usr/local/lib/
COPY --from=builder /usr/local/lib/libtrantor.so* /usr/local/lib/

# Update shared library cache
RUN ldconfig

WORKDIR /app
EXPOSE 8080

CMD ["./drogon-app"]
