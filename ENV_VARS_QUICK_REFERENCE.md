# Quick Reference: Environment Variables

## Backend Service (kratos-backend)

```bash
# Required - From Railway PostgreSQL Plugin
DATABASE_URL=${{Postgres.DATABASE_URL}}

# Required - Your Railway URLs (update after first deploy)
RAILWAY_PUBLIC_URL=https://kratos-backend-production-XXXX.up.railway.app
KRATOS_BROWSER_URL=https://kratos-ui-production-XXXX.up.railway.app

# Required - Cookie Configuration
COOKIE_DOMAIN=.up.railway.app

# Required - Mailtrap SMTP (get from your Mailtrap sandbox)
MAILTRAP_SMTP_URI=smtp://username:password@smtp.mailtrap.io:2525

# Required - Secrets (generate with: openssl rand -hex 32)
SECRETS_COOKIE=your-32-char-random-secret-here
SECRETS_CIPHER=your-32-char-random-secret-here
```

## Frontend Service (kratos-ui)

```bash
# Required - Point to backend (update after backend is deployed)
KRATOS_PUBLIC_URL=https://kratos-backend-production-XXXX.up.railway.app

# Required - Point to itself (update after this service is deployed)
KRATOS_BROWSER_URL=https://kratos-ui-production-XXXX.up.railway.app

# Required - Cookie Configuration
COOKIE_SECRET=your-32-char-random-secret
CSRF_COOKIE_NAME=ory_csrf_ui
CSRF_COOKIE_SECRET=your-32-char-random-secret

# Optional - Port (Railway auto-detects)
PORT=3000
```

## Generate Secure Secrets

Run these commands to generate secure random secrets:

```bash
openssl rand -hex 32  # For SECRETS_COOKIE
openssl rand -hex 32  # For SECRETS_CIPHER
openssl rand -hex 32  # For COOKIE_SECRET
openssl rand -hex 32  # For CSRF_COOKIE_SECRET
```

## Deployment Order

1. ✅ Deploy PostgreSQL plugin
2. ✅ Deploy backend with DATABASE_URL (use temporary URLs for others)
3. ✅ Get backend Railway URL
4. ✅ Deploy frontend
5. ✅ Get frontend Railway URL
6. ✅ Update both services with correct URLs
7. ✅ Redeploy both services
8. ✅ Run migrations: `kratos migrate sql -e --yes -c /etc/kratos/kratos.yml`
