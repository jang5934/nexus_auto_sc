#!/bin/bash

# 사용법: bash install-nexus-node.sh <NODE_ID>

set -e

if [ -z "$1" ]; then
  echo "❌ Node ID를 입력하세요. 예: bash install-nexus-node.sh 8078010"
  exit 1
fi

NODE_ID=$1
SESSION_NAME="nexus-node"

echo "📦 종속성 설치 중..."
sudo apt update -y
sudo apt install -y curl wget jq screen -y

echo "🧾 config.json 생성 중 (Terms of Use 우회)..."
mkdir -p ~/.nexus
echo "{\"node_id\": \"$NODE_ID\"}" > ~/.nexus/config.json

echo "⬇️ Nexus CLI 설치 중..."
screen -S "$SESSION_NAME" -dm bash -c "
  curl -s https://cli.nexus.xyz/ | sh && \
  source ~/.bashrc && \
  nexus-network start --node-id=$NODE_ID >> ~/nexus-node.log 2>&1
"

echo "✅ 설치 및 실행 완료. screen 세션 이름: $SESSION_NAME"
echo "👉 접속: screen -r $SESSION_NAME"
