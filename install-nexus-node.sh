#!/bin/bash

# 사용법: bash install-nexus-node.sh <NODE_ID>
# 예시: bash install-nexus-node.sh 8078010

set -e

if [ -z "$1" ]; then
  echo "❌ Node ID를 입력하세요. 예: bash install-nexus-node.sh 8078010"
  exit 1
fi

NODE_ID=$1
INSTALL_DIR="/opt/nexus-cli"
SERVICE_NAME="nexus-node"
CONFIG_DIR="/root/.nexus"
CONFIG_FILE="${CONFIG_DIR}/config.json"
BINARY_URL="https://github.com/nexus-xyz/nexus-cli/releases/download/v0.8.13/nexus-network-linux-x86_64"

echo "📦 종속성 설치..."
sudo apt update -y
sudo apt install -y curl wget jq

echo "📁 디렉토리 생성..."
sudo mkdir -p "$INSTALL_DIR"
sudo mkdir -p "$CONFIG_DIR"

echo "⬇️ Nexus CLI 다운로드 중..."
sudo wget -q -L -O "$INSTALL_DIR/nexus" "$BINARY_URL"
sudo chmod +x "$INSTALL_DIR/nexus"

echo "🧾 Node ID를 ~/.nexus/config.json 에 저장..."
sudo bash -c "cat > $CONFIG_FILE" <<EOF
{
  "node_id": "$NODE_ID"
}
EOF

echo "🛠️ systemd 서비스 등록 중: ${SERVICE_NAME}.service"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Nexus CLI Node ($NODE_ID)
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash -c '${INSTALL_DIR}/nexus start --node-id=$NODE_ID'
WorkingDirectory=${INSTALL_DIR}
Restart=always
RestartSec=5
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

echo "🔄 systemd 서비스 적용..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable "$SERVICE_NAME"
sudo systemctl start "$SERVICE_NAME"

echo "✅ 설치 및 실행 완료. 서비스 상태:"
sudo systemctl status "$SERVICE_NAME" --no-pager
