FROM ubuntu:lunar

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
  && apt dist-upgrade -y \
  && apt install -y curl \
  build-essential \
  ca-certificates \
  llvm-dev \
  libclang-dev \
  git \
  gzip \
  zip \
  unzip \
  file \
  net-tools \
  pkg-config \
  neovim \
  vim \
  make \
  lsof \
  inetutils-ping \
  inetutils-telnet \
  openssl \
  libssl-dev \
  zsh \
  sccache \
  fish

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

COPY config.toml /root/.cargo/config.toml

RUN $HOME/.cargo/bin/cargo install cargo-udeps --locked

RUN $HOME/.cargo/bin/rustup install nightly

RUN $HOME/.cargo/bin/rustup component add rust-analyzer

RUN ln -s $($HOME/.cargo/bin/rustup which --toolchain stable rust-analyzer) $HOME/.cargo/bin/rust-analyzer

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog 
