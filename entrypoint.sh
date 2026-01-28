#!/bin/sh
set -e

echo "===================================="
echo "Ory Kratos Startup Script"
echo "===================================="

if [ -z "$DATABASE_URL" ]; then
    echo "ERROR: DATABASE_URL is not set"
    exit 1
fi

echo "Running database migrations..."
kratos migrate sql --yes -c /etc/config/kratos/kratos.yml

echo "Migrations completed successfully!"
echo ""
echo "Starting Kratos server..."
echo "===================================="

exec kratos serve -c /etc/config/kratos/kratos.yml --dev --watch-courier