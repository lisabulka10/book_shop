#!/bin/bash
set -e

echo "Waiting for PostgreSQL..."
while ! nc -z db 5432; do
  sleep 0.5
done
echo "db:5432 - accepting connections"

echo "Waiting for Redis..."
while ! nc -z redis 6379; do
  sleep 0.5
done
echo "Connection to redis succeeded!"

echo "Starting Gunicorn..."
exec gunicorn -b 0.0.0.0:8000 wsgi:app
