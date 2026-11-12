ralph_version := "28.8.0"
rust_version := "1.99.1"

rust_image := "ghcr.io/zon/ralph-rust"

# List the available recipes.
default:
    @just --list

# Build every Ralph image.
build: build-rust

# Confirm every built image carries its toolchain.
test: test-rust

# Push every local development tag to GHCR.
push: push-rust

# Build the Rust Ralph image.
build-rust:
    podman build \
      --build-arg RALPH_VERSION={{ralph_version}} \
      --build-arg RUST_VERSION={{rust_version}} \
      -t {{rust_image}}:dev \
      -f containers/rust/Containerfile containers/rust

# Confirm the Rust image carries the Rust toolchain.
test-rust: build-rust
    podman run --rm --entrypoint /bin/sh {{rust_image}}:dev -lc \
      'rustc --version && cargo --version && rustfmt --version && cargo clippy --version'

# Push the Rust development tag to GHCR.
push-rust:
    podman push {{rust_image}}:dev
