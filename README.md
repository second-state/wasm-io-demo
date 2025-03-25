# Intro

This is a demo environment prepared using Docker, which includes:

- WasmEdge and the wasi-http plugin built from commit `85451f99c00bcf17f362f3190d2680c52a0ac49b`.

- A wasm app generated using wasm-tools 1.207 from the [source](https://github.com/second-state/component-model-tests/tree/main/http).

For more details, please refer to the [Dockerfile](Dockerfile).

```bash
docker pull ghcr.io/second-state/wasm-io-demo:latest

docker run -it --rm ghcr.io/second-state/wasm-io-demo:latest

Or append uri parameter

docker run -it --rm ghcr.io/second-state/wasm-io-demo:latest "https://www.google.com"
```