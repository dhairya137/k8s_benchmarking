FROM ubuntu:22.04

# Install all dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    pkg-config \
    g++ \
    git \
    ca-certificates \
    libssl-dev \
    libjsoncpp-dev \
    uuid-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Drogon Framework
WORKDIR /tmp
RUN git clone --depth 1 --branch v1.9.9 https://github.com/drogonframework/drogon && \
    cd drogon && \
    git submodule update --init && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DBUILD_POSTGRESQL=OFF \
          -DBUILD_MYSQL=OFF \
          -DBUILD_SQLITE=OFF \
          -DBUILD_REDIS=OFF \
          -DBUILD_BROTLI=OFF \
          .. && \
    make && \
    make install && \
    ldconfig

# Build and run the application
WORKDIR /app
COPY . .
RUN mkdir -p build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make

EXPOSE 8080

CMD ["./build/drogon-app"]
