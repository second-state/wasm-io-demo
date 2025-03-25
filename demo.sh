#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "No arguments provided. Using default URL: https://example.org"
    set -- "https://example.org"
else
    echo "Running demo with arguments: $@"
fi

echo "WasmEdge version: $(wasmedge --version)"
exec wasmedge --enable-component /app/http.wasm run "$@"
