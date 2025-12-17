#!/bin/sh
set -e

# 默认值
VPN_USERNAME="${VPN_USERNAME:-$1}"
VPN_PASSWORD="${VPN_PASSWORD:-$2}"
LAN_IP="${LAN_IP:-$3}"
GW_LAN_IP="${GW_LAN_IP:-$4}"
NET_INTERFACE="${NET_INTERFACE:-$5}"
NGINX_ENABLE="${NGINX_ENABLE:-0}"


# 建立 VPN 连接
connect_vpn() {
    # 建立连接
    openvpn --config /etc/openvpn/client/client.opvn --auth-user-pass /etc/openvpn/client/user-passwd.txt &
}

# 路由表
ip_routes() {
    ip route add $VPN_SERVER via $GW_LAN_IP dev $NET_INTERFACE metric 100
    ip route add $LAN_IP via $GW_LAN_IP dev eth0 metric 70
    ip route add default dev ppp0 metric 50
    ip route del default via $GW_LAN_IP dev $NET_INTERFACE
}

# Nginx
start_nginx_if_enabled() {
  if [ "$NGINX_ENABLE" = "1" ]; then
    nginx
  fi
}


# 主函数
main() {
    # 建立连接
    connect_vpn
    # 路由
    ip_routes
    # Nginx
    start_nginx_if_enabled
    # 保持容器运行
    tail -f /dev/null
}

# 运行主函数
main
