FROM docker.io/cachyos/cachyos-v3:latest AS blublu-arch

# Pacman Initialization
# Create build user
RUN pacman-key --init && pacman-key --populate && \
    pacman -Syu --noconfirm && \
    echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    pacman -S --clean --clean \
    && sed -i 's/-march=native/-march=x86-64/g' /etc/makepkg.conf

# Install packages Distrobox adds automatically, this speeds up first launch
RUN pacman -S \
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
    sdl12-compat \
    rav1e \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    tevent \
    ttf-ms-win10-auto \
    mesa-git \
    lib32-mesa-git \
    libjpeg6-turbo \
    xorg-xwayland \
    cachyos/umu-launcher \
    cachyos/cachyos-gaming-meta \
    cachyos/proton-ge-custom \
    --noconfirm && \
    rm -rf /var/cache/pacman/pkg/*

# Distrobox Integration
RUN git clone https://github.com/89luca89/distrobox.git --single-branch /tmp/distrobox && \
    cp /tmp/distrobox/distrobox-host-exec /usr/bin/distrobox-host-exec && \
    ln -s /usr/bin/distrobox-host-exec /usr/bin/flatpak && \
    wget https://github.com/1player/host-spawn/releases/download/$(cat /tmp/distrobox/distrobox-host-exec | grep host_spawn_version= | cut -d "\"" -f 2)/host-spawn-$(uname -m) -O /usr/bin/host-spawn && \
    chmod +x /usr/bin/host-spawn && \
    rm -drf /tmp/distrobox

# Cleanup
RUN sed -i 's@#en_US.UTF-8@en_US.UTF-8@g' /etc/locale.gen && \
    sed -i '/root ALL=(ALL) NOPASSWD: ALL/d' /etc/sudoers && \
    rm -rf /tmp/* \
    && sed -i 's/-march=x86-64/-march=native/g' /etc/makepkg.conf
