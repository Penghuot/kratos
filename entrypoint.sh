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

# Railway uses 'postgresql://' but Kratos needs 'postgres://'
# Transform the DATABASE_URL if needed
export DSN=$(echo "$DATABASE_URL" | sed 's/^postgresql:/postgres:/')

echo "DATABASE_URL is set"
echo "DSN configured for Kratos"

# Substitute environment variables in the config file
echo "Substituting environment variables in config..."
envsubst < /etc/kratos/kratos.yml > /tmp/kratos.yml

echo ""
echo "Running database migrations..."
kratos -c /tmp/kratos.yml migrate sql -e --yes

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

# Start Kratos
exec kratos -c /tmp/kratos.yml serve --dev --watch-courier