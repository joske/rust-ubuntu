FROM ubuntu:jammy

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive
ENV USER="rust"

RUN apt update && apt dist-upgrade && \
  apt install -y software-properties-common && add-apt-repository ppa:neovim-ppa/unstable && apt update && \
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
  protobuf-compiler \
  fish

#install lazygit
COPY lazygit.sh /tmp/
RUN chmod +x /tmp/lazygit.sh && /tmp/lazygit.sh && rm /tmp/lazygit.sh

#install sccache
COPY sccache.sh /tmp/
RUN chmod +x /tmp/sccache.sh && /tmp/sccache.sh && rm /tmp/sccache.sh

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
COPY --chown=$USER:$USER tmux.conf /home/$USER/.tmux.conf

# fish (must be before rust as rustup will setup some fish paths)
RUN mkdir -p /home/rust/.config/fish/conf.d/
RUN /usr/bin/fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
RUN /usr/bin/fish -c "fisher install IlanCosman/tide@v5.0.1"
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
