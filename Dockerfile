FROM python:3.12-slim
WORKDIR /srv
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt boto3==1.35.99
COPY app app
COPY scripts/build_job.py scripts/build_job.py
COPY build-formats.json .
COPY static static
COPY themes/mkdocs-latex/theme themes/mkdocs-latex/theme
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "1", "--threads", "2", "--timeout", "900", "app.vitepress_worker:app"]
