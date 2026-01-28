#!/bin/sh
set -e

echo "===================================="
echo "Ory Kratos Startup Script"
echo "===================================="

# Check required environment variables
if [ -z "$DATABASE_URL" ]; then
    echo "ERROR: DATABASE_URL is not set"
    exit 1
fi

echo "DATABASE_URL is set"
echo "Running database migrations..."
echo ""

# Run migrations with -e flag to read DSN from environment
kratos migrate sql -e --yes -c /etc/config/kratos/kratos.yml

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Migrations completed successfully!"
else
    echo ""
    echo "❌ Migration failed!"
    exit 1
fi

echo ""
echo "Starting Kratos server..."
echo "===================================="
echo "Public API will be available on port ${PORT:-4433}"
echo "Admin API will be available on port 4434"
echo ""

# Start Kratos server
exec kratos serve -c /etc/config/kratos/kratos.yml --dev --watch-courier