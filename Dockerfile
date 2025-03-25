FROM wasmedge/wasmedge:ubuntu-build-gcc AS build
RUN apt update && apt install -y libssl-dev

RUN git clone https://github.com/WasmEdge/WasmEdge.git
RUN cd WasmEdge && git checkout 85451f99c00bcf17f362f3190d2680c52a0ac49b
RUN cmake -S /WasmEdge -B /build -GNinja \
    -DCMAKE_BUILD_TYPE=Debug\
    -DWASMEDGE_BUILD_TOOLS=ON \
    -DWASMEDGE_PLUGIN_WASI_HTTP=ON \
    -DWASMEDGE_USE_LLVM=OFF
RUN cmake --build /build

FROM rust:1.82 AS app
ADD component-model-tests /src

RUN /bin/bash <<EOT
    set -ex
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
    cargo binstall wasm-tools --version 1.207 -y
    wasm-tools parse src/http/http.wat -o http.wasm
EOT

FROM build AS out
COPY --from=app /http.wasm /app/http.wasm

ENV WASMEDGE_PLUGIN_PATH=/build/plugins/wasi_http
ENV PATH="/build/tools/wasmedge/:${PATH}"

COPY demo.sh /usr/local/bin/demo.sh
RUN chmod +x /usr/local/bin/demo.sh

ENTRYPOINT ["/usr/local/bin/demo.sh"]