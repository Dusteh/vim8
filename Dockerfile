FROM ubuntu:18.04

ENV TZ America/Mexico_City

ARG USER
ARG UID
ARG GID

ENV USER $USER
ENV HOME /home/$USER
ENV UID $UID
ENV GID $GID

RUN groupadd --gid $GID $USER

RUN useradd --create-home --home-dir $HOME \
        --gid $GID \
        --uid $UID \
        $USER
RUN usermod -aG sudo $USER
RUN id $USER

RUN apt-get update && apt-get install -y \
        locales \
        tzdata \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        --no-install-recommends

RUN locale-gen --purge en_US.UTF-8
RUN echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
        libcanberra-gtk-module \
        build-essential \
        gnome-devel \
        xterm \
        libncurses5-dev \ 
        python3-dev \
        checkinstall \
        xorg \
        libxt-dev \
        papirus-icon-theme \
        git

RUN mkdir -p /tmp/build && \
    cd /tmp/build && \
    git clone https://github.com/vim/vim.git && \ 
    cd vim && \
    git checkout tags/v8.1.0229 && \
    ./configure --with-features=huge \
                --enable-cscope \
                --enable-gnome-check \
                --enable-gtk3-check \
                --enable-gui=gtk3 \
                --enable-multibyte \
                --enable-python3interp=yes \
                --with-python3-config-dir=/usr/lib/python3.6/config \
                --enable-fail-if-missing && \
    make && \
    checkinstall

RUN apt-get remove --purge -y \
        xorg \
        gnome-devel \
        xterm \
        libncurses5-dev \ 
        libxt-dev 

RUN mkdir -p $HOME/fonts
COPY fonts $HOME/fonts
RUN $HOME/fonts/install.sh

USER $USER

ENTRYPOINT [ "bash" ]
