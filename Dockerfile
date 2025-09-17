FROM python:3.12-slim

WORKDIR /app


RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
        netcat-openbsd \
        ca-certificates \
        gnupg \
        wget \
        lsb-release \
        apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

RUN chmod +x entrypoint.sh

CMD ["./entrypoint.sh"]
