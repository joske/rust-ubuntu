FROM ubuntu:jammy

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive
ENV USER="rust"

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
  tmux \
  libssl-dev \
  zsh \
  sudo

# create a non root user
RUN groupadd $USER
RUN useradd -g $USER -G root -s /bin/bash $USER
RUN mkdir -p /home/$USER
RUN chown $USER:$USER /home/$USER

# allow sudo without password
RUN echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USER
WORKDIR /home/$USER

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# COPY config.toml /root/.cargo/config.toml

# RUN $HOME/.cargo/bin/cargo install cargo-udeps --locked

RUN $HOME/.cargo/bin/rustup install nightly

RUN $HOME/.cargo/bin/rustup component add rust-analyzer

RUN ln -sf $($HOME/.cargo/bin/rustup which --toolchain stable rust-analyzer) $HOME/.cargo/bin/rust-analyzer

RUN echo export PATH=$PATH:$HOME/.cargo/bin >> $HOME/.bashrc

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog 
