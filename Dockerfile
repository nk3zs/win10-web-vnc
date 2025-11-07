# Sử dụng image Ubuntu desktop có sẵn noVNC
FROM dorowu/ubuntu-desktop-lxde-vnc:bionic

LABEL maintainer="ChatGPT Render Win10 Web"

# Cập nhật và cài gói cơ bản (không có wine ở đây)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget curl software-properties-common \
        xfce4-terminal \
        lxappearance \
        fonts-liberation && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Cài WINE từ repo chính thức của WineHQ (phiên bản cho Ubuntu 18.04)
RUN dpkg --add-architecture i386 && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key && \
    apt-key add winehq.key && \
    add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' && \
    apt-get update && \
    apt-get install -y --install-recommends winehq-stable && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Thêm hình nền Windows 10
RUN mkdir -p /usr/share/backgrounds && \
    wget -O /usr/share/backgrounds/win10.jpg https://wallpapercave.com/wp/wp9644955.jpg && \
    echo '[Desktop Entry]\nType=Application\nExec=pcmanfm --set-wallpaper=/usr/share/backgrounds/win10.jpg\nHidden=false' > /etc/xdg/autostart/set-wallpaper.desktop

# Đặt cổng noVNC (web) và VNC server
EXPOSE 6080 5900
ENV PORT=6080

# Khởi động GUI + VNC qua web
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
