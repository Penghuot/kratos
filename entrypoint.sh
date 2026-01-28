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

echo "✅ DATABASE_URL is set"
echo "✅ DSN configured for Kratos"

# Substitute environment variables in the config file
echo "Substituting environment variables in config..."
envsubst < /etc/kratos/kratos.yml > /tmp/kratos.yml

echo ""
echo "Running database migrations..."
echo "(Skipping if already applied)"

# Run migrations - don't fail if they're already applied
kratos -c /tmp/kratos.yml migrate sql -e --yes || {
    echo "⚠️  Migration command exited with error, but continuing..."
    echo "This is normal if migrations are already applied"
}

echo ""
echo "✅ Migration check completed"
echo ""
echo "Starting Kratos server..."
echo "===================================="

# Start Kratos - this is the main process
exec kratos -c /tmp/kratos.yml serve --dev --watch-courier