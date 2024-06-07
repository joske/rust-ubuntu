# Development environment for Rust

- based on Ubuntu 22.04 LTS
- Installs latest stable and nightly rust
- fish/bash/zsh shells
- neovim + my (minimal) astronvim config (https://github.com/joske/astronvim_v4)
- lots of tools (ripgrep, fzf, curl, telnet, ping, tmux)

build with

```bash
docker build -t rust-ubuntu:snarkos .
```

run with

```bash
docker run -d -ti --init --name snarkos rust-ubuntu:snarkos fish
```

You can mount your host sources into the container using `-v <local>:/home/rust/source` in the above `docker run` command.
