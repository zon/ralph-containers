# Ralph Containers

Container images for [Ralph](https://github.com/zon/ralph) remote workflows. Each image extends the Ralph executor with a language toolchain so a project can build and test inside an Argo Workflow instead of on the developer's machine.

## Images

| Image | Contents |
| --- | --- |
| `ghcr.io/zon/ralph-rust` | Rust stable with `rustfmt` and `clippy`, plus native build dependencies for Bevy, Winit, audio, and gamepad crates |

## Use an image

Point Ralph at a published tag in `.ralph/config.yaml`:

```yaml
mode: remote

workflow:
  image:
    repository: ghcr.io/zon/ralph-rust
    tag: ralph-28.5.6-rust-1.99.1
```

The `latest` tag follows the `main` branch. Pin a version tag for reproducible runs.

## Build locally

The base Ralph image is an argument, so an image can track a different Ralph release:

```bash
podman build \
  --build-arg RALPH_VERSION=28.5.6 \
  --build-arg RUST_VERSION=1.99.1 \
  -t ghcr.io/zon/ralph-rust:dev \
  -f containers/rust/Containerfile containers/rust
```

Or use the just recipes:

```bash
just build
just test
```

`just test` runs `rustc`, `cargo`, `rustfmt`, and `clippy` inside the built image.

## Publish

The `Publish containers` GitHub Actions workflow builds every image on pull requests and pushes `linux/amd64` images to GHCR on `main` and on manual dispatch. It authenticates with `GITHUB_TOKEN` and uses the repository's `packages: write` permission.

Published packages are public so remote workflows can pull them without an image pull secret. If GitHub creates a future package as private, set it to public from **Package settings → Danger Zone → Change visibility**. Public package visibility is separate from repository visibility, and cannot be reversed.

## Layout

```text
containers/
  rust/
    Containerfile
```

Add each new toolchain as its own directory and add a matrix entry to `.github/workflows/publish.yml`.
