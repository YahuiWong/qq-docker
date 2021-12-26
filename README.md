[![Docker Size](https://img.shields.io/docker/image-size/yahuiwong/qq)](https://hub.docker.com/r/yahuiwong/qq)
[![Docker Pulls](https://img.shields.io/docker/pulls/yahuiwong/qq)](https://hub.docker.com/r/yahuiwong/qq)

# 运行
```
docker run --name qq \
  -p {VNC端口}:5900 \
  -p {WEB端口}:6080 \
  -e VNC_SERVER_PASSWD='{VNC密码}' \
  yahuiwong/qq
```

## 通过VNC访问
默认端口为5900，使用任何VNC客户端连接，如[VNC® Viewer](https://www.realvnc.com/en/connect/download/viewer/)，[TightVNC](https://www.tightvnc.com/)。

## 通过浏览器访问
默认端口为6080。
