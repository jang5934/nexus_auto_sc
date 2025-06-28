#!/bin/bash

# 사용법: bash install-nexus.sh <NODE_ID>
set -e

if [ -z "$1" ]; then
  echo "❌ Node ID를 입력하세요. 예: bash install-nexus.sh 8078010"
  exit 1
fi

NODE_ID=$1
INSTALL_DIR="/opt/nexus-cli"
CONFIG_DIR="/root/.nexus"
CONFIG_FILE="${CONFIG_DIR}/config.json"
BINARY_URL="https://github.com/nexus-xyz/nexus-cli/releases/download/v0.8.13/nexus-network-linux-x86_64"

echo "📦 종속성 설치..."
sudo apt update -y
sudo apt install -y curl wget jq -qq

echo "📁 디렉토리 생성..."
sudo mkdir -p "$INSTALL_DIR"
sudo mkdir -p "$CONFIG_DIR"

echo "⬇️ Nexus CLI 다운로드 중..."
sudo wget -q -O "$INSTALL_DIR/nexus" "$BINARY_URL"
sudo chmod +x "$INSTALL_DIR/nexus"

echo "🧾 config.json 저장..."
sudo bash -c "cat > $CONFIG_FILE" <<EOF
{
  "node_id": "$NODE_ID"
}
EOF

echo "✅ 설치 완료"
