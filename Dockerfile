# syntax = docker/dockerfile:1.5

FROM rust:alpine3.18
RUN apk add --no-cache tree b3sum
ARG TARGETARCH

RUN mkdir /mtime
RUN mkdir /artifacts

WORKDIR /mtime

ARG CACHE_EPOCH

COPY . .

RUN --mount=type=cache,sharing=shared,id=cargo_registry_index,target=${CARGO_HOME}/registry/index \
    --mount=type=cache,sharing=shared,id=cargo_registry_cache,target=${CARGO_HOME}/registry/cache \
    --mount=type=cache,sharing=shared,id=cargo_git,target=${CARGO_HOME}/git/db \
    --mount=type=cache,sharing=shared,id=target_${TARGETARCH},target=/mtime/target \
    --mount=type=cache,sharing=shared,id=retimer,target=/mtime/retimer-state \
    echo "current time" && \
    date && \
    echo "retimer output before build" && \
    cat retimer-state/file_info.txt && \
    echo "${CARGO_HOME}/registry/index" && \
    tree -apuD "${CARGO_HOME}/registry/index" && \
    echo "${CARGO_HOME}/registry/cache" && \
    tree -apuD "${CARGO_HOME}/registry/cache" && \
    echo "${CARGO_HOME}/git/db" && \
    tree -apuD "${CARGO_HOME}/git/db" && \
    echo "/mtime" && \
    tree -apuD "/mtime" && \
    cargo build --release && \
    echo "retimer output after build" && \
    ./retimer.sh && \
    cat retimer-state/file_info.txt && \
    cp /mtime/target/release/mtime-cache-test /artifacts/mtime-cache-test

ENTRYPOINT [ "/artifacts/mtime-cache-test" ]
