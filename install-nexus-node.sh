#!/bin/bash

# 사용법: bash install-nexus-node.sh <NODE_ID>
# 예시: bash install-nexus-node.sh 8078010

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

echo "⬇️ Nexus CLI 설치 중 (비대화 모드)..."
# screen 세션 생성 및 명령 실행
screen -S "$SESSION_NAME" -dm bash -c "
  NONINTERACTIVE=1 curl -s https://cli.nexus.xyz/ | sh && \
  source ~/.bashrc && \
  nexus-network start --node-id=$NODE_ID >> ~/nexus-node.log 2>&1
"

echo "✅ 설치 완료 및 실행 중! screen 세션 이름: $SESSION_NAME"
echo "👉 screen에 접속하려면: screen -r $SESSION_NAME"
echo "👉 로그 파일: ~/nexus-node.log"
