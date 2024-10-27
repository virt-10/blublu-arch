FROM docker.io/cachyos/cachyos-v3:latest AS blublu-arch


# Install packages Distrobox adds automatically, this speeds up first launch
RUN sed -i 's/-march=native/-march=x86-64/g' /etc/makepkg.conf \
    && pacman-key --init && pacman-key --populate \
    && pacman -Syu --noconfirm \
    && echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && pacman -S --clean --clean \
    && pacman -S \
        adw-gtk-theme \
        bash-completion \
        bc \
        curl \
        diffutils \
        findutils \
        glibc \
        gnupg \
        inetutils \
        keyutils \
        less \
        lsof \
        man-db \
        man-pages \
        mlocate \
        mtr \
        ncurses \
        nss-mdns \
        openssh \
        pigz \
        pinentry \
        procps-ng \
        rsync \
        shadow \
        sudo \
        tcpdump \
        time \
        traceroute \
        tree \
        tzdata \
        unzip \
        util-linux \
        util-linux-libs \
        vte-common \
        wget \
        words \
        xorg-xauth \
        zip \
        mesa \
        opengl-driver \
        vulkan-intel \
        vte-common \
        vulkan-radeon \
        wget \
        paru \
        cachyos-v3/lib32-zlib-ng \
        cachyos-v3/lib32-zlib-ng-compat \
        xdg-desktop-portal-hyprland \
        xdg-desktop-portal-gtk \
        --noconfirm && \
    rm -rf /var/cache/pacman/pkg/*

# Distrobox Integration
RUN git clone https://github.com/89luca89/distrobox.git --single-branch /tmp/distrobox && \
    cp /tmp/distrobox/distrobox-host-exec /usr/bin/distrobox-host-exec && \
    ln -s /usr/bin/distrobox-host-exec /usr/bin/flatpak && \
    wget https://github.com/1player/host-spawn/releases/download/$(cat /tmp/distrobox/distrobox-host-exec | grep host_spawn_version= | cut -d "\"" -f 2)/host-spawn-$(uname -m) -O /usr/bin/host-spawn && \
    chmod +x /usr/bin/host-spawn && \
    rm -drf /tmp/distrobox \
    && sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers \
    && rm -rf /tmp/* \
    && sed -i 's/-march=x86-64/-march=native/g' /etc/makepkg.conf
