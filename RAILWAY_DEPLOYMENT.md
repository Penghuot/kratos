# Railway Deployment Guide for Ory Kratos

This guide will help you deploy your forked Ory Kratos (https://github.com/Penghuot/kratos.git) to Railway with both the backend and selfservice UI.

## 📋 Prerequisites

1. Railway account (https://railway.app)
2. Mailtrap account with sandbox SMTP credentials
3. Your forked Kratos repo: https://github.com/Penghuot/kratos.git

## 🏗️ Architecture

- **Kratos Backend Service**: Handles authentication APIs (Public: 4433, Admin: 4434)
- **Kratos UI Service**: Selfservice UI for login, registration, etc.
- **PostgreSQL Database**: Railway's managed PostgreSQL plugin

---

## 📦 Files Included

### 1. `Dockerfile.backend`
Dockerfile for Kratos backend service that builds from your fork.

### 2. `kratos.yml`
Kratos configuration using Railway environment variables.

### 3. `identity.schema.json`
Identity schema for email-based authentication.

### 4. `Dockerfile.frontend`
Dockerfile for the selfservice UI (uses official ory/kratos-selfservice-ui-node).

---

## 🚀 Railway Deployment Steps

### Step 1: Create New Railway Project

1. Go to https://railway.app
2. Click **"New Project"**
3. Select **"Empty Project"**
4. Name it (e.g., "kratos-auth")

### Step 2: Add PostgreSQL Database

1. In your project, click **"+ New"**
2. Select **"Database"** → **"PostgreSQL"**
3. Railway will automatically create a PostgreSQL instance
4. Note: Railway automatically creates a `DATABASE_URL` variable

### Step 3: Deploy Kratos Backend Service

1. Click **"+ New"** → **"GitHub Repo"**
2. Connect your GitHub account if not already connected
3. Select your forked repo: **Penghuot/kratos**
4. Railway will detect the repo

#### Configure Backend Service:

1. **Settings** → **General**:
   - Service Name: `kratos-backend`
   - Root Directory: `/` (leave as root)

2. **Settings** → **Build**:
   - Builder: `Dockerfile`
   - Dockerfile Path: `Dockerfile.backend`

3. **Settings** → **Deploy**:
   - Add custom start command (leave empty, Dockerfile handles it)

4. **Variables** tab - Add these environment variables:

```bash
# Database (automatically available from PostgreSQL plugin)
DATABASE_URL=${{Postgres.DATABASE_URL}}

# Backend URL (use Railway's provided domain)
# After first deploy, get the URL from Settings → Networking → Public Networking
# Format: https://kratos-backend-production-XXXX.up.railway.app
RAILWAY_PUBLIC_URL=https://kratos-backend-production-XXXX.up.railway.app

# Frontend URL (we'll update this after deploying frontend)
KRATOS_BROWSER_URL=https://kratos-ui-production-XXXX.up.railway.app

# Cookie Domain (extract from frontend URL, e.g., kratos-ui-production-XXXX.up.railway.app)
COOKIE_DOMAIN=.up.railway.app

# Mailtrap SMTP URI
# Format: smtp://username:password@smtp.mailtrap.io:2525
MAILTRAP_SMTP_URI=smtp://YOUR_MAILTRAP_USERNAME:YOUR_MAILTRAP_PASSWORD@smtp.mailtrap.io:2525

# Secrets (change these to secure random values in production)
SECRETS_COOKIE=CHANGE-THIS-TO-RANDOM-32-CHAR-SECRET
SECRETS_CIPHER=CHANGE-THIS-TO-RANDOM-32-CHAR-SECRET
```

5. **Settings** → **Networking**:
   - Enable **Public Networking**
   - Note the generated domain (e.g., `kratos-backend-production-XXXX.up.railway.app`)

### Step 4: Deploy Kratos UI Service

1. Click **"+ New"** → **"Empty Service"**
2. Name it: `kratos-ui`

#### Configure UI Service:

1. **Settings** → **General**:
   - Service Name: `kratos-ui`

2. **Settings** → **Source**:
   - Connect to your GitHub repo: **Penghuot/kratos**

3. **Settings** → **Build**:
   - Builder: `Dockerfile`
   - Dockerfile Path: `Dockerfile.frontend`

4. **Variables** tab - Add these environment variables:

```bash
# Point to your Kratos backend service
# Use the URL from Step 3 (backend domain)
KRATOS_PUBLIC_URL=https://kratos-backend-production-XXXX.up.railway.app

# Point to this UI service itself
# After first deploy, get URL from Settings → Networking
KRATOS_BROWSER_URL=https://kratos-ui-production-XXXX.up.railway.app

# Cookie secrets (must match backend for session sharing)
COOKIE_SECRET=changeme-use-random-32-chars
CSRF_COOKIE_NAME=ory_csrf_ui
CSRF_COOKIE_SECRET=changeme-use-random-32-chars

# Port (Railway auto-detects, but can specify)
PORT=3000
```

5. **Settings** → **Networking**:
   - Enable **Public Networking**
   - Note the generated domain

### Step 5: Update Environment Variables

After both services are deployed:

1. Go back to **kratos-backend** service
2. Update these variables with actual URLs:
   - `RAILWAY_PUBLIC_URL` = your backend Railway URL
   - `KRATOS_BROWSER_URL` = your frontend Railway URL
   - `COOKIE_DOMAIN` = `.up.railway.app` (or specific domain if using custom domain)

3. Go to **kratos-ui** service
4. Update:
   - `KRATOS_PUBLIC_URL` = your backend Railway URL
   - `KRATOS_BROWSER_URL` = your frontend Railway URL

5. Redeploy both services for changes to take effect

### Step 6: Run Database Migrations

After backend is deployed and connected to PostgreSQL:

1. Go to **kratos-backend** service
2. Click **"..."** (three dots) → **"Command"** or use the **Deployments** tab
3. Open a terminal/shell in the running container
4. Run migration command:

```bash
kratos migrate sql -e --yes -c /etc/kratos/kratos.yml
```

Alternatively, you can create a one-off migration service:

1. Create new service from same repo
2. Set Dockerfile to `Dockerfile.backend`
3. Override start command in **Settings** → **Deploy**:
   ```bash
   kratos migrate sql -e --yes -c /etc/kratos/kratos.yml
   ```
4. Deploy once, then remove the service after successful migration

---

## 🔐 Environment Variables Reference

### Backend Service (kratos-backend)

| Variable | Description | Example |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string (from Railway plugin) | `postgresql://user:pass@host:5432/db` |
| `RAILWAY_PUBLIC_URL` | Your Kratos backend public URL | `https://kratos-backend-production-XXXX.up.railway.app` |
| `KRATOS_BROWSER_URL` | Your UI frontend URL (for CORS & redirects) | `https://kratos-ui-production-XXXX.up.railway.app` |
| `COOKIE_DOMAIN` | Domain for session cookies | `.up.railway.app` |
| `MAILTRAP_SMTP_URI` | Mailtrap SMTP connection string | `smtp://user:pass@smtp.mailtrap.io:2525` |
| `SECRETS_COOKIE` | Cookie encryption secret (32 chars min) | Random string |
| `SECRETS_CIPHER` | Data encryption secret (32 chars min) | Random string |

### Frontend Service (kratos-ui)

| Variable | Description | Example |
|----------|-------------|---------|
| `KRATOS_PUBLIC_URL` | Backend API URL | `https://kratos-backend-production-XXXX.up.railway.app` |
| `KRATOS_BROWSER_URL` | Frontend UI URL (itself) | `https://kratos-ui-production-XXXX.up.railway.app` |
| `COOKIE_SECRET` | Cookie signing secret | Random string (32 chars) |
| `CSRF_COOKIE_NAME` | CSRF cookie name | `ory_csrf_ui` |
| `CSRF_COOKIE_SECRET` | CSRF token secret | Random string (32 chars) |
| `PORT` | HTTP port (optional, Railway auto-detects) | `3000` |

---

## ✅ Testing Your Deployment

1. **Check Backend Health**:
   ```bash
   curl https://kratos-backend-production-XXXX.up.railway.app/health/ready
   ```

2. **Access UI**:
   - Open: `https://kratos-ui-production-XXXX.up.railway.app`
   - You should see the Kratos selfservice UI

3. **Test Registration Flow**:
   - Go to registration page
   - Create an account
   - Check Mailtrap inbox for verification email

4. **Test Login**:
   - Login with created account
   - Verify session cookies are set correctly

---

## 🐛 Troubleshooting

### Issue: "Database connection failed"
- Verify `DATABASE_URL` is correctly set from PostgreSQL plugin
- Check PostgreSQL service is running
- Ensure migrations have run successfully

### Issue: "CORS errors in browser"
- Verify `KRATOS_BROWSER_URL` matches your frontend URL exactly
- Check CORS configuration in `kratos.yml`
- Ensure both services are using HTTPS

### Issue: "Session not persisting after login"
- Check `COOKIE_DOMAIN` is set correctly (`.up.railway.app` for Railway domains)
- Verify cookies are being set with `SameSite=Lax`
- Ensure both backend and frontend use same domain suffix

### Issue: "Emails not sending"
- Verify `MAILTRAP_SMTP_URI` is correct
- Check Mailtrap dashboard for connection attempts
- Review backend logs for SMTP errors

### Issue: "Migration fails"
- Ensure PostgreSQL is fully initialized before running migrations
- Check database credentials are correct
- Review migration logs in Railway dashboard

---

## 🔒 Security Notes (Production Readiness)

**⚠️ This is a DEV setup. For production:**

1. **Generate secure secrets**:
   ```bash
   # Use strong random values, not the defaults
   openssl rand -hex 32  # For SECRETS_COOKIE
   openssl rand -hex 32  # For SECRETS_CIPHER
   openssl rand -hex 32  # For COOKIE_SECRET
   openssl rand -hex 32  # For CSRF_COOKIE_SECRET
   ```

2. **Use production SMTP** (not Mailtrap sandbox)

3. **Configure custom domain** instead of Railway URLs

4. **Set `COOKIE_DOMAIN`** to your custom domain

5. **Remove `--dev` flag** from Kratos start command in Dockerfile

6. **Set proper `LOG_LEVEL`** (not `debug` in production)

7. **Enable HTTPS** enforcement (Railway provides this automatically)

8. **Review and harden** CORS settings in `kratos.yml`

---

## 📚 Additional Resources

- [Ory Kratos Documentation](https://www.ory.sh/docs/kratos/)
- [Railway Documentation](https://docs.railway.app/)
- [Kratos Configuration Reference](https://www.ory.sh/docs/kratos/reference/configuration)
- [Your Forked Repo](https://github.com/Penghuot/kratos)

---

## 🎯 Quick Start Checklist

- [ ] Create Railway project
- [ ] Add PostgreSQL database
- [ ] Deploy backend service with `Dockerfile.backend`
- [ ] Deploy UI service with `Dockerfile.frontend`
- [ ] Set all environment variables
- [ ] Update URLs after first deploy
- [ ] Run database migrations
- [ ] Test registration flow
- [ ] Test login flow
- [ ] Check email delivery in Mailtrap

---

**Your Kratos deployment should now be live! 🚀**

Access your UI at: `https://kratos-ui-production-XXXX.up.railway.app`
