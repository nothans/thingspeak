#!/bin/bash
set -e

# Wait for MySQL to accept connections
echo "Waiting for MySQL at ${DATABASE_HOST:-db}..."
until ruby -e "require 'socket'; TCPSocket.new('${DATABASE_HOST:-db}', 3306).close" 2>/dev/null; do
  sleep 2
done
echo "MySQL is ready!"

# Remove stale PID file
rm -f /app/tmp/pids/server.pid

# Create database if it doesn't exist, then load schema
bundle exec rake db:create RAILS_ENV=development 2>/dev/null || true
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:schema:load RAILS_ENV=development 2>/dev/null </dev/null || true

exec "$@"
