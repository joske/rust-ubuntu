FROM ubuntu:noble

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive
ENV USER="rust"

RUN apt update && apt dist-upgrade && \
  apt install -y neovim \
  curl \
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
  vim \
  make \
  lsof \
  fzf \
  ripgrep \
  yarn \
  nodejs \
  npm \
  lldb \
  inetutils-ping \
  inetutils-telnet \
  openssl \
  tmux \
  libssl-dev \
  zsh \
  sudo \
  sccache \
  fish

# create a non root user
RUN groupadd $USER
RUN useradd -g $USER -G root -s /bin/bash $USER
RUN mkdir -p /home/$USER
RUN chown $USER:$USER /home/$USER

# allow sudo without password
RUN echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USER
WORKDIR /home/$USER

# tmux
COPY tmux.conf /home/$USER/.tmux.conf

# fish
RUN mkdir -p /home/rust/.config/fish/conf.d/

# rust stuff
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN $HOME/.cargo/bin/rustup install nightly
RUN $HOME/.cargo/bin/rustup component add rust-analyzer
RUN ln -sf $($HOME/.cargo/bin/rustup which --toolchain stable rust-analyzer) $HOME/.cargo/bin/rust-analyzer
RUN echo export PATH=$PATH:$HOME/.cargo/bin >> $HOME/.bashrc
COPY config.toml /root/.cargo/config.toml

# install my neovim config
RUN git clone -b minimal https://github.com/joske/astronvim_v4 ~/.config/nvim

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog 
