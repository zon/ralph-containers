# Ralph Containers

Container images for [Ralph](https://github.com/zon/ralph) remote workflows. Each image extends the Ralph executor with a language toolchain so a project can build and test inside an Argo Workflow instead of on the developer's machine.

The Ralph image carries Ralph, the argo command line, and OpenCode. It carries no language toolchain. Each image here adds one.

## Images

| Image | Contents |
| --- | --- |
| `ghcr.io/zon/ralph-go` | Go toolchain with `air` for live reload and `templ` for templates |
| `ghcr.io/zon/ralph-rust` | Rust stable with `rustfmt` and `clippy`, plus native build dependencies for Bevy, Winit, audio, and gamepad crates |

The Go image does not install a C compiler. A project that needs cgo adds one in its own image or before commands.

## Use an image

Point Ralph at a published tag in `.ralph/config.yaml`:

```yaml
mode: remote

workflow:
  image:
    repository: ghcr.io/zon/ralph-go
    tag: ralph-28.8.0-go-1.27.4
```

The `latest` tag follows the `main` branch. Pin a version tag for reproducible runs.

## Build locally

The base Ralph image is an argument, so an image can track a different Ralph release:

```bash
podman build \
  --build-arg RALPH_VERSION=28.8.0 \
  --build-arg GO_VERSION=1.27.4 \
  -t ghcr.io/zon/ralph-go:dev \
  -f containers/go/Containerfile containers/go
```

Or use the just recipes:

```bash
just build
just test
```

Name one image to build only that image, for example `just build-go` or `just test-rust`. `just test` runs each toolchain command inside its built image.

## Publish

The `Publish containers` GitHub Actions workflow builds every image on pull requests and pushes `linux/amd64` images to GHCR on `main` and on manual dispatch. It scans each image with Trivy, fails on a critical finding, and authenticates with `GITHUB_TOKEN` using the repository's `packages: write` permission.

Published packages are public so remote workflows can pull them without an image pull secret. If GitHub creates a future package as private, set it to public from **Package settings → Danger Zone → Change visibility**. Public package visibility is separate from repository visibility, and cannot be reversed.

## Layout

```text
containers/
  go/
    Containerfile
  rust/
    Containerfile
```

Add each new toolchain as its own directory and add a matrix entry to `.github/workflows/publish.yml`.
