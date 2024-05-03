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

# fish (must be before rust as rustup will setup some fish paths)
RUN mkdir -p /home/rust/.config/fish/conf.d/
RUN /usr/bin/fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
RUN /usr/bin/fish -c "fisher install IlanCosman/tide@v6"
RUN /usr/bin/fish -c "tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='One line' --prompt_spacing=Compact --icons='Many icons' --transient=No"

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
