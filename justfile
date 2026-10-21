ralph_version := "28.5.6"
rust_version := "1.99.1"
image := "ghcr.io/zon/ralph-rust"

# List the available recipes.
default:
    @just --list

# Build the Rust Ralph image.
build:
    podman build \
      --build-arg RALPH_VERSION={{ralph_version}} \
      --build-arg RUST_VERSION={{rust_version}} \
      -t {{image}}:dev \
      -f containers/rust/Containerfile containers/rust

# Confirm the image carries the Rust toolchain.
test: build
    podman run --rm --entrypoint /bin/sh {{image}}:dev -lc \
      'rustc --version && cargo --version && rustfmt --version && cargo clippy --version'

# Push the local development tag to GHCR.
push:
    podman push {{image}}:dev
