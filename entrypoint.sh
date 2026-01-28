#!/bin/sh
set -e

echo "===================================="
echo "Ory Kratos Startup Script"
echo "===================================="

# Check if required environment variables are set
if [ -z "$DATABASE_URL" ]; then
    echo "ERROR: DATABASE_URL is not set"
    exit 1
fi

echo "Running database migrations..."
kratos migrate sql -e --yes -c /etc/config/kratos/kratos.yml

echo "Migrations completed successfully!"
echo ""
echo "Starting Kratos server..."
echo "===================================="

# Start Kratos server
exec kratos serve -c /etc/config/kratos/kratos.yml --dev --watch-courier
