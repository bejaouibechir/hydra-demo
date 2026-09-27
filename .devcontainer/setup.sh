#!/bin/bash
# Runs once when the Codespace is created.
set -e

echo "==> Installing Hydra ETL"
pip install --quiet --upgrade pip
pip install --quiet "hydra-etl[server]>=0.11.3" mysql-connector-python

echo "==> Starting the MySQL container"
docker compose up -d

echo "==> Waiting for MySQL to accept connections"
for _ in $(seq 1 60); do
  if docker compose exec -T mysql mysqladmin ping -h 127.0.0.1 -uroot -proot-demo >/dev/null 2>&1; then
    echo "    MySQL is up on port 3307"
    break
  fi
  sleep 2
done

echo
echo "Ready. Three things you can do now:"
echo "  1. hdrctl workflow run workflows/nightly-report.yaml"
echo "  2. hdrctl serve --port 5678      (Hydra Studio, opens in a browser tab)"
echo "  3. docker compose ps             (the container your pipeline talks to)"
