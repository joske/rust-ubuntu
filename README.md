# Development environment for Rust

- based on Ubuntu 22.04 LTS
- clones snarkOS and snarkVM
- Installs latest stable and nightly rust
- fish/bash/zsh shells
- neovim + my (minimal) astronvim config (https://github.com/joske/astronvim_v4)
- lots of tools

build with

```bash
docker build -t rust-ubuntu:snarkos .
```

run with

```bash
docker run -d -ti --init --name snarkos rust-ubuntu:snarkos fish
```
