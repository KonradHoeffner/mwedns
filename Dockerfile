# syntax=docker/dockerfile:1
FROM clux/muslrust:1.83.0-stable AS musl
#USER root
WORKDIR /app
COPY . .
ARG CARGO_INCREMENTAL=0
# trying to resolve URLs, just show errors, don't abort
# this *works* in rootless Docker
RUN curl -sS -o /dev/null https://google.com; exit 0
# this *fails* in rootless Docker in musl
RUN curl -sS -o /dev/null https://github.com; exit 0
RUN cargo build --release --target x86_64-unknown-linux-musl
CMD ["/app/target/x86_64-unknown-linux-musl/release/mwedns"]

FROM rust:1.83.0-slim
WORKDIR /app
COPY . .
ARG CARGO_INCREMENTAL=0
# this *works* in rootless Docker with the official Rust image
RUN curl -sS -o /dev/null https://google.com; exit 0
# this *fails* in rootless Docker with the normal Rust image
RUN curl -sS -o /dev/null https://github.com; exit 0
RUN cargo build --release
COPY --link --from=musl /app/target/x86_64-unknown-linux-musl/release/mwedns /app/musl
# run the one compiled with the official Rust image first
CMD echo "official Rust" && /app/target/release/mwedns && echo "musl Rust" && /app/musl
