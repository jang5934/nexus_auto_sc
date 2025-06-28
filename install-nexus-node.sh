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
BINARY_URL="https://github.com/nexus-xyz/nexus-cli/releases/download/v0.8.13/nexus-network-linux-x86_64"
BINARY_PATH="${INSTALL_DIR}/nexus"

echo "📦 종속성 설치 중..."
sudo apt update -y
sudo apt install -y curl wget jq

# tmux 설치 여부 확인
if ! command -v tmux &> /dev/null; then
  echo "📦 tmux가 설치되어 있지 않아 설치를 진행합니다..."
  sudo apt install -y tmux
else
  echo "✅ tmux가 이미 설치되어 있습니다."
fi

echo "📁 디렉토리 생성 중..."
sudo mkdir -p "$INSTALL_DIR"

echo "⬇️ Nexus CLI 바이너리 다운로드 중..."
sudo wget -q -L -O "$BINARY_PATH" "$BINARY_URL"
sudo chmod +x "$BINARY_PATH"

echo "🚀 tmux 세션으로 노드 실행 중..."
tmux new -d -s nexus-node "$BINARY_PATH start --node-id=$NODE_ID"

echo "✅ 설치 및 실행 완료! tmux 세션 이름: nexus-node"
