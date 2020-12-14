#!/bin/sh
#显示时间
date
cat << EOF > /usr/local/etc/v2ray/config.json
 {
          "log": {
            "access": "none",
            "loglevel": "error"
          },
          "inbounds": [
            {
              "port": 8080,
              "protocol": "vless",
              "settings": {
                "decryption": "none",
                "clients": [
                  {
                    "id": "${V2_UUID}"
                  }
                ]
              },
              "streamSettings": {
                "network":"ws",
                "wsSettings": {
                  "path": "${V2_WS_PATH_VLESS}"
                }
              }
            }
          ],
          "outbounds": [
            {
              "protocol": "freedom"
            }
          ]
        }
EOF
# Run V2Ray
VERSION=$(/usr/local/bin/v2ray --version |grep V |awk '{print $2}')
REBOOTDATE=$(date)
sed -i "s/VERSION/$VERSION/g" /var/lib/nginx/html/index.html
sed -i "s/REBOOTDATE/$REBOOTDATE/g" /var/lib/nginx/html/index.html
nohup /usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json >v2.txt 2>&1 &
# start nginx
nginx
tail -f /dev/null
