ralph_version := "28.8.0"
rust_version := "1.99.1"
go_version := "1.27.4"

rust_image := "ghcr.io/zon/ralph-rust"
go_image := "ghcr.io/zon/ralph-go"

# List the available recipes.
default:
    @just --list

# Build every Ralph image.
build: build-rust build-go

# Confirm every built image carries its toolchain.
test: test-rust test-go

# Push every local development tag to GHCR.
push: push-rust push-go

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

# Build the Go Ralph image.
build-go:
    podman build \
      --build-arg RALPH_VERSION={{ralph_version}} \
      --build-arg GO_VERSION={{go_version}} \
      -t {{go_image}}:dev \
      -f containers/go/Containerfile containers/go

# Confirm the Go image carries the Go toolchain, air, and templ.
test-go: build-go
    podman run --rm --entrypoint /bin/sh {{go_image}}:dev -lc \
      'go version && command -v air && templ version'

# Push the Go development tag to GHCR.
push-go:
    podman push {{go_image}}:dev
