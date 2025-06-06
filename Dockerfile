FROM ubuntu:noble

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive
# Ubuntu base image already has a user named ubuntu, using this avoids permissions issues with bind mounts
ENV USER="ubuntu"

RUN apt update && apt dist-upgrade -y && \
  apt install -y \
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
  protobuf-compiler \
  fish

#install lazygit
COPY lazygit.sh /tmp/
RUN chmod +x /tmp/lazygit.sh && /tmp/lazygit.sh && rm /tmp/lazygit.sh

# allow sudo without password
RUN echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# change the shell to fish
RUN chsh -s /usr/bin/fish $USER

# install neovim ppa
RUN apt install -y software-properties-common && add-apt-repository ppa:neovim-ppa/unstable -y && \
  apt update && \
  apt install -y neovim

USER $USER
WORKDIR /home/$USER

# tmux
COPY --chown=$USER:$USER tmux.conf /home/$USER/.tmux.conf

# fish (must be before rust as rustup will setup some fish paths)
RUN mkdir -p /home/$USER/.config/fish/conf.d/
RUN /usr/bin/fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
RUN /usr/bin/fish -c "fisher install IlanCosman/tide@v6"
RUN /usr/bin/fish -c "tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='24-hour format' --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='One line' --prompt_spacing=Compact --icons='Many icons' --transient=No"
RUN /usr/bin/fish -c "alias -s vim nvim"
RUN /usr/bin/fish -c "alias -s lg lazygit"

# rust stuff
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN $HOME/.cargo/bin/rustup install nightly
RUN echo export PATH=$PATH:$HOME/.cargo/bin >> $HOME/.bashrc
COPY --chown=$USER:$USER config.toml /home/$USER/.cargo/config.toml

# install my neovim config
RUN git clone -b minimal https://github.com/joske/astronvim_v4 ~/.config/nvim

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog 
