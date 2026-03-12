#!/bin/bash
set -e

# Wait for MySQL to accept connections
echo "Waiting for MySQL at ${DATABASE_HOST:-db}..."
until mysqladmin ping -h "${DATABASE_HOST:-db}" -u "${DATABASE_USER:-thing}" -p"${DATABASE_PASSWORD:-speak}" --silent 2>/dev/null; do
  sleep 2
done
echo "MySQL is ready!"

# Create database if it doesn't exist, then load schema
bundle exec rake db:create 2>/dev/null || true
bundle exec rake db:schema:load 2>/dev/null || true

exec "$@"
