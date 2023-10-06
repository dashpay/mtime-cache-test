# syntax = docker/dockerfile:1.5

FROM rust:alpine3.18

ARG TARGETARCH

RUN mkdir /mtime
RUN mkdir /artifacts

WORKDIR /mtime

COPY . .

RUN --mount=type=cache,sharing=shared,id=cargo_registry_index,target=${CARGO_HOME}/registry/index \
    --mount=type=cache,sharing=shared,id=cargo_registry_cache,target=${CARGO_HOME}/registry/cache \
    --mount=type=cache,sharing=shared,id=cargo_git,target=${CARGO_HOME}/git/db \
    --mount=type=cache,sharing=shared,id=target_${TARGETARCH},target=/mtime/target \
    cargo build --release && \
    cp /mtime/target/release/mtime-cache-test /artifacts/mtime-cache-test

ENTRYPOINT [ "/artifacts/mtime-cache-test" ]
