#!/bin/bash
# Runs once when the Codespace is created.
# MySQL is already up: docker compose waited for its healthcheck before
# starting this container, so there is nothing to wait for here.
set -e

echo "==> Installing Hydra ETL"
pip install --quiet --upgrade pip
pip install --quiet "hydra-etl[server]>=0.11.3" mysql-connector-python

echo "==> Checking the database"
python3 - <<'PY'
import os
try:
    import mysql.connector as m
    c = m.connect(host="mysql", port=3306, user=os.environ["MYSQL_USER"],
                  password=os.environ["MYSQL_PASSWORD"], database="orders_dev")
    cur = c.cursor(); cur.execute("SELECT COUNT(*) FROM orders"); n = cur.fetchone()[0]
    print(f"    orders table reachable on host 'mysql' ({n} rows)")
except Exception as e:
    print(f"    WARNING: could not reach MySQL yet: {e}")
    print("    Steps 1 and 2 of the README still work. Try: docker compose logs mysql")
PY

echo
echo "Ready. Three things you can do now:"
echo "  1. hdrctl workflow run workflows/nightly-report.yaml"
echo "  2. hdrctl serve --port 5678      (Hydra Studio, opens in a browser tab)"
echo "  3. cat parameters.yaml           (where the host and port come from)"
