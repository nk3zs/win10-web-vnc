# =========================
# Ubuntu 20.04 Desktop (fake Windows 10) + VNC + noVNC + Wine
# =========================
FROM dorowu/ubuntu-desktop-lxde-vnc:focal

LABEL maintainer="ChatGPT Render Win10 Web"

# Cập nhật hệ thống & cài các gói cơ bản + Wine
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        wget curl software-properties-common \
        xfce4-terminal \
        lxappearance \
        fonts-liberation \
        wine64 \
        winbind \
        cabextract && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Thêm hình nền Windows 10
RUN mkdir -p /usr/share/backgrounds && \
    wget -O /usr/share/backgrounds/win10.jpg https://wallpapercave.com/wp/wp9644955.jpg && \
    echo '[Desktop Entry]\nType=Application\nExec=pcmanfm --set-wallpaper=/usr/share/backgrounds/win10.jpg\nHidden=false' > /etc/xdg/autostart/set-wallpaper.desktop

# (Tuỳ chọn) Chạy lần đầu để tạo prefix Wine
RUN wineboot --init || true

# Mở port noVNC (6080) và VNC (5900)
EXPOSE 6080 5900
ENV PORT=6080

# Khởi động GUI và noVNC
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
