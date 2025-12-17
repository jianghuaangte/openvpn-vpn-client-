FROM alpine:edge

# 设置环境变量
ENV VPN_USERNAME=""
ENV VPN_PASSWORD=""
ENV LAN_IP=""
ENV GW_LAN_IP=""
ENV NET_INTERFACE=""
ENV AUTO_RECONNECT="true"
ENV CHECK_INTERVAL="15"
ENV MAX_RETRIES="3"

# 安装必要的软件包
RUN apk update && apk upgrade openssl libcrypto3 libssl3 && apk add --no-cache \
    openvpn \
    net-tools \
    nginx \
    curl \
    neovim \
    && rm -rf /var/cache/apk/*

# 复制入口脚本
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x \
    /usr/local/bin/entrypoint.sh

# 设置入口点
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
