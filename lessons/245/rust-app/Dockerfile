FROM rust:1.80.1-bookworm AS build

WORKDIR /app

COPY . .

RUN cargo build --release

FROM debian:12.6-slim

RUN apt-get update && apt-get install -y ca-certificates

COPY --from=build /app/target/release/rust-app /rust-app

# Add environment variables to match C++ implementation behavior(This env are not getting used just for starting app)
ENV POSTGRES_HOST=10.0.0.94 \
    POSTGRES_USER=postgres \
    POSTGRES_PWD=devops123 \
    POSTGRES_DB=mydb \
    POSTGRES_POOL=5

CMD ["/rust-app"]
