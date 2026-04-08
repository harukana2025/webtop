# ベースはUbuntu版Webtop
FROM lscr.io/linuxserver/webtop:ubuntu-xfce

# 管理者権限でインストール作業
USER root

# 必要なツールとAntigravityリポジトリの追加
RUN apt-get update && apt-get install -y curl gpg ffmpeg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://pkg.dev | gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://pkg.dev antigravity-debian main" | tee /etc/apt/sources.list.d/antigravity.list && \
    apt-get update && apt-get install -y antigravity && \
    apt-get clean

# Hugging Face等のポート(7860)対応（必要な場合のみ）
# 3000番のまま使う環境なら下の行は不要です
RUN sed -i 's/3000/7860/g' /etc/s6-overlay/s6-rc.d/init-webtop-config/run || true

# 一般ユーザーに戻す
USER abc
WORKDIR /config
