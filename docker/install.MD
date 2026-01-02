# 原生安装

::: warning 注意
原生安装比较复杂，不建议新手尝试。
:::

## 编译 Apache Guacamole-Server

> 参考 Apache Guacamole-Server 官方编译文档 https://guacamole.apache.org/doc/gug/installing-guacamole.html#building-guacamole-server

安装依赖

::: code-group

```shell [Debian]
apt install -y make gcc g++ \
  libcairo2-dev libjpeg62-turbo-dev libpng-dev libtool-bin uuid-dev libossp-uuid-dev \
  freerdp2-dev libvncserver-dev libpulse-dev libvorbis-dev libwebp-dev
```

```shell [Ubuntu]
apt install -y make gcc g++ \
  libcairo2-dev libjpeg-turbo8-dev libpng-dev libtool-bin uuid-dev libossp-uuid-dev \
  freerdp2-dev libvncserver-dev libpulse-dev libvorbis-dev libwebp-dev
```

```shell [Fedora / CentOS / RHEL]
yum install -y make gcc g++ \
  cairo-devel libjpeg-turbo-devel libjpeg-devel libpng-devel libtool libuuid-devel \
  freerdp-devel libvncserver-devel pulseaudio-libs-devel libvorbis-devel libwebp-devel
```

:::

下载源码

```shell
wget https://downloads.apache.org/guacamole/1.6.0/source/guacamole-server-1.6.0.tar.gz
```

解压
```shell
tar -xvf guacamole-server-1.6.0.tar.gz
```

编译安装
```shell
cd guacamole-server-1.6.0
./configure --with-init-dir=/etc/init.d
make
make install
ldconfig
```

生成配置文件

``` bash
mkdir /etc/guacamole/ && cat <<EOF > /etc/guacamole/guacd.conf
[daemon]
pid_file = /var/run/guacd.pid
log_level = info

[server]
bind_host = 127.0.0.1
bind_port = 4822
EOF
```

安装服务

``` bash
cat <<EOF > /etc/systemd/system/guacd.service
[Unit]
Description=Guacamole proxy daemon
Documentation=man:guacd(8)
After=network.target

[Service]
User=root
ExecStart=/usr/local/sbin/guacd -f /etc/guacamole/guacd.conf
TimeoutSec=0
RestartSec=10
Restart=always
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF
```

启动 guacd 服务

``` bash
systemctl daemon-reload
systemctl enable guacd
systemctl start guacd
```

## 安装 Next Terminal

下载

```shell
wget https://github.com/dushixiang/next-terminal/releases/latest/download/next-terminal.tar.gz
```

解压
```shell
mkdir -p /usr/local/next-terminal/
tar -zxvf next-terminal.tar.gz -C /usr/local/next-terminal
```

::: tip 提示
请自行安装 `postgres` 数据库，支持 16.x 及以上版本。

安装完成后，请修改 `config.yaml` 文件中的 `database` 配置。
:::

使用系统服务方式启动
``` bash
cat <<EOF > /etc/systemd/system/next-terminal.service
[Unit]
Description=next-terminal service
After=network.target

[Service]
User=root
WorkingDirectory=/usr/local/next-terminal
ExecStart=/usr/local/next-terminal/next-terminal -c /usr/local/next-terminal/config.yaml
TimeoutSec=0
RestartSec=10
Restart=always
LimitNOFILE=1048576

[Install]
WantedBy=multi-user.target
EOF
```

启动 Next-Terminal 服务

```shell
systemctl daemon-reload
systemctl enable next-terminal
systemctl start next-terminal
```

::: tip 安装成功后
访问 http://{ip}:8088/setup 进行用户初始化设置

访问 http://{ip}:8088/login 进行登陆