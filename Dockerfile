FROM python:3.12-slim
WORKDIR /srv
RUN apt-get update && apt-get install -y --no-install-recommends git fuse curl ca-certificates && rm -rf /var/lib/apt/lists/*
ARG TIGRISFS_VERSION=1.2.1
RUN ARCH=$(uname -m) && case "$ARCH" in x86_64) ARCH=amd64 ;; aarch64) ARCH=arm64 ;; *) exit 1 ;; esac && curl -fL "https://github.com/tigrisdata/tigrisfs/releases/download/v${TIGRISFS_VERSION}/tigrisfs_${TIGRISFS_VERSION}_linux_${ARCH}.tar.gz" -o /tmp/tigrisfs.tar.gz && tar -xzf /tmp/tigrisfs.tar.gz -C /usr/local/bin/ && rm /tmp/tigrisfs.tar.gz && chmod +x /usr/local/bin/tigrisfs
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app app
COPY scripts/build_job.py scripts/build_job.py
COPY build-formats.json .
COPY static static
COPY themes/mkdocs-latex/theme themes/mkdocs-latex/theme
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "1", "--threads", "2", "--timeout", "900", "app.vitepress_worker:app"]
