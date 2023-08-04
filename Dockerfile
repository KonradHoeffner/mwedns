# syntax=docker/dockerfile:1
FROM clux/muslrust:1.73.0-nightly-2023-08-01 AS chef
USER root
RUN cargo install cargo-chef
WORKDIR /app

FROM chef AS planner
ARG CARGO_INCREMENTAL=0
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder
ARG CARGO_INCREMENTAL=0
COPY --link --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --target x86_64-unknown-linux-musl --recipe-path recipe.json
COPY . .
RUN cargo build --release --target x86_64-unknown-linux-musl

FROM busybox:1.36.1 AS runtime
RUN addgroup -S myuser && adduser -S myuser -G myuser
COPY --link --from=builder /app/target/x86_64-unknown-linux-musl/release/mwedns /usr/local/bin/
USER myuser
WORKDIR /app
CMD ["/usr/local/bin/mwedns"]
