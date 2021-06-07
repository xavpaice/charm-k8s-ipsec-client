FROM ubuntu:latest
WORKDIR /opt/src

RUN set -eux; \
	apt-get update \
  && apt-get install -y --no-install-recommends \
      strongswan \
      iptables \
      kmod \
      iproute2 \
      ipvsadm \
  && apt-get -y clean \
	&& rm -rf /var/lib/apt/lists/*

COPY ./ipsec.secrets /etc/ipsec.secrets
COPY ./ipsec.conf /etc/ipsec.conf
COPY ./ipsec.conf.example /opt/src/ipsec.conf
COPY ./ipsec.secrets.example /opt/src/ipsec.secrets
RUN chmod 600 /etc/ipsec.secrets

COPY ./run.sh /opt/src/run.sh
RUN chmod 755 /opt/src/run.sh

EXPOSE 500/udp 4500/udp 8080/tcp
CMD ["/usr/sbin/ipsec stop ; /usr/sbin/ipsec start --nofork"]

ARG BUILD_DATE
ARG VERSION
ARG VCS_REF
ENV IMAGE_VER $BUILD_DATE

LABEL maintainer="Xav Paice <xavpaice@gmail.com>" \
    org.opencontainers.image.created="$BUILD_DATE" \
    org.opencontainers.image.version="$VERSION" \
    org.opencontainers.image.revision="$VCS_REF" \
    org.opencontainers.image.authors="Xav Paice <xavpaice@gmail.com>" \
    org.opencontainers.image.title="IPsec VPN endpoint on Docker" \
    org.opencontainers.image.description="Docker image to run an IPsec VPN endpoint." \
    org.opencontainers.image.url="https://github.com/xavpaice/charm-k8s-ipsec-client" \
    org.opencontainers.image.source="https://github.com/xavpaice/charm-k8s-ipsec-client.git" \
    org.opencontainers.image.documentation="todo"

