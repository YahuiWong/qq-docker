FROM ubuntu:20.04

RUN  sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list &&\
sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

ENV noVNC_Version="1.3.0"
ENV qq_Version="2.0.0-b2-1089"

ENV VNC_SERVER_PASSWD password

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV LANGUAGE zh_CN:zh

# Variables needed for non interactive tzdata installation.
ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get -qqy update && \
  apt-get -qqy install \
    supervisor \
    wget \
    x11vnc \
    xvfb \
    websockify \
    i3status \
    i3-wm \
    desktop-file-utils \
    libappindicator3-1 \
    libasound2 \
    libnss3 \
    libgtk-3-0 \
    libfontconfig \
    libfreetype6 \
    libgbm-dev \
    libnotify4 \
    libsecret-1-0 \
    xfonts-cyrillic \
    xfonts-scalable \
    fonts-liberation \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    xdg-utils && \
  rm -rf /var/lib/apt/lists/* && \
  apt-get -qyy clean

RUN mkdir /root/.vnc && \
  touch /root/.vnc/passwd

RUN wget \
    https://down.qq.com/qqweb/LinuxQQ/linuxqq_${qq_Version}_amd64.deb \
    -O qq.deb && \
  dpkg -i qq.deb && \
  rm qq.deb -f

RUN wget \
    https://github.com/novnc/noVNC/archive/refs/tags/v${noVNC_Version}.tar.gz -O novnc.tar.gz && \
  mkdir -p /root/novnc && \
  tar -xzf novnc.tar.gz -C /root/novnc && \
  rm novnc.tar.gz websockify.tar.gz -f &&\
  mv /root/novnc/noVNC-${noVNC_Version} /root/novnc/noVNC

# Remove cap_net_admin capabilities to avoid failing with 'operation not permitted'.
RUN setcap -r `which i3status`

COPY supervisord.conf /root/supervisord.conf
COPY i3_config /root/.config/i3/config

EXPOSE 5900
EXPOSE 6080

CMD echo "VNC (vnc://localhost:5900) password is $VNC_SERVER_PASSWD" && \
  /usr/bin/x11vnc -storepasswd $VNC_SERVER_PASSWD ~/.vnc/passwd && \
  /usr/bin/supervisord -c /root/supervisord.conf && \
  /usr/bin/tail -f /dev/null
