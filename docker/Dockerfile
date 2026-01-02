FROM ubuntu:24.04 AS builder
ARG GUACAMOLE_VERSION=1.6.0
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    wget \
    build-essential \
    make \
    gcc \
    g++ \
    libcairo2-dev \
    libjpeg-turbo8-dev \
    libpng-dev \
    libtool-bin \
    uuid-dev \
    libossp-uuid-dev \
    freerdp2-dev \
    libvncserver-dev \
    libpulse-dev \
    libvorbis-dev \
    libwebp-dev \
    pkg-config \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
COPY docker/guacamole-server-${GUACAMOLE_VERSION}.tar.gz .
RUN tar -xzf guacamole-server-${GUACAMOLE_VERSION}.tar.gz

WORKDIR /tmp/guacamole-server-${GUACAMOLE_VERSION}
RUN ./configure --with-init-dir=/etc/init.d
RUN make -j$(nproc)
RUN make install
RUN ldconfig

FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libcairo2 \
    libjpeg-turbo8 \
    libpng16-16 \
    uuid-runtime \
    libossp-uuid16 \
    libfreerdp2-2 \
    libvncserver1 \
    libpulse0 \
    libvorbis0a \
    libwebp7 \
    libtool \
    libssl3 \
    libx11-6 \
    libxcb-render0 \
    libxkbcommon0 \
  && rm -rf /var/lib/apt/lists/*

RUN ldconfig

COPY --from=builder /usr/local /usr/local
RUN mkdir -p /etc/guacamole

COPY docker/guacd.conf /etc/guacamole/guacd.conf
COPY docker/next-terminal /usr/local/next-terminal
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME ["/usr/local/next-terminal/data/sqlite","/usr/local/next-terminal/data/recording","/usr/local/next-terminal/data/drive"]

WORKDIR /usr/local/next-terminal

EXPOSE 8088 2022 4822

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/next-terminal/next-terminal"]

