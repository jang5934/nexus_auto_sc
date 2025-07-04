#!/bin/bash

# 사용법: bash install-and-run-nexus.sh <NODE_ID>
# 예시: bash install-and-run-nexus.sh 8078010

set -e

if [ -z "$1" ]; then
  echo "❌ Node ID를 입력하세요. 예: bash install-and-run-nexus.sh 8078010"
  exit 1
fi

NODE_ID=$1
SESSION_NAME="nexus-node"

# screen 설치 확인
if ! command -v screen &> /dev/null; then
  echo "📦 screen이 설치되어 있지 않아 설치를 진행합니다..."
  sudo apt update -y
  sudo apt install -y screen
else
  echo "✅ screen이 이미 설치되어 있습니다."
fi

# screen 세션 생성 및 명령 실행
echo "🚀 screen 세션($SESSION_NAME)에서 Nexus 노드 실행 시작..."
screen -dmS "$SESSION_NAME" bash -c "
curl -s https://cli.nexus.xyz/ | sh && \
source ~/.bashrc && \
nexus-network start --node-id=$NODE_ID
"

echo "✅ 백그라운드 실행 완료. 다음 명령어로 세션 확인:"
echo "  screen -ls"
echo "다시 접속하려면:"
echo "  screen -r $SESSION_NAME"
