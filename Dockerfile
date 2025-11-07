# =========================
# Ubuntu Desktop giả Windows 10 có GUI + VNC qua Web
# =========================
FROM dorowu/ubuntu-desktop-lxde-vnc

LABEL maintainer="ChatGPT Windows Web Builder"

# Cập nhật & cài các gói cần thiết
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget curl software-properties-common \
        xfce4-terminal \
        lxappearance \
        fonts-liberation \
        wine && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Đặt theme và wallpaper giống Windows 10
RUN mkdir -p /usr/share/backgrounds && \
    wget -O /usr/share/backgrounds/win10.jpg https://wallpapercave.com/wp/wp9644955.jpg && \
    echo '[Desktop Entry]\nType=Application\nExec=pcmanfm --set-wallpaper=/usr/share/backgrounds/win10.jpg\nHidden=false' > /etc/xdg/autostart/set-wallpaper.desktop

# (Tuỳ chọn) Cài thêm app Windows giả lập
RUN winecfg || true

# Mở cổng VNC (5900) và web VNC (6080)
EXPOSE 5900 6080

# Render cần port web
ENV PORT=6080

# Lệnh mặc định khởi động GUI + noVNC
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
