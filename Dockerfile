# Ubuntu desktop có noVNC
FROM dorowu/ubuntu-desktop-lxde-vnc:focal

LABEL maintainer="ChatGPT Render Win10 Web"

# Xóa repo Chrome lỗi trước khi update
RUN rm -f /etc/apt/sources.list.d/google-chrome.list || true

# Cập nhật hệ thống & cài gói cơ bản + Wine
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

# Khởi tạo Wine prefix lần đầu
RUN wineboot --init || true

# Mở port noVNC (6080) và VNC (5900)
EXPOSE 6080 5900
ENV PORT=6080

# Chạy GUI + noVNC
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
