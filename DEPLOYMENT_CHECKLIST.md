# Railway Deployment Checklist

Use this checklist to track your deployment progress.

## ☑️ Pre-Deployment

- [ ] Railway account created
- [ ] Mailtrap account set up
- [ ] Mailtrap SMTP credentials obtained
- [ ] Generated secure secrets (run `openssl rand -hex 32` 4 times)
- [ ] These files are committed to your fork:
  - [ ] `Dockerfile.backend`
  - [ ] `Dockerfile.frontend`
  - [ ] `kratos.yml`
  - [ ] `identity.schema.json`

## ☑️ Railway Project Setup

- [ ] Created new Railway project
- [ ] Added PostgreSQL database plugin
- [ ] Noted PostgreSQL `DATABASE_URL` variable

## ☑️ Backend Service Deployment

- [ ] Created backend service from GitHub repo
- [ ] Set Dockerfile path to `Dockerfile.backend`
- [ ] Added environment variables:
  - [ ] `DATABASE_URL=${{Postgres.DATABASE_URL}}`
  - [ ] `RAILWAY_PUBLIC_URL` (temporary URL for now)
  - [ ] `KRATOS_BROWSER_URL` (temporary URL for now)
  - [ ] `COOKIE_DOMAIN=.up.railway.app`
  - [ ] `MAILTRAP_SMTP_URI=smtp://user:pass@smtp.mailtrap.io:2525`
  - [ ] `SECRETS_COOKIE=<your-32-char-secret>`
  - [ ] `SECRETS_CIPHER=<your-32-char-secret>`
- [ ] Enabled public networking
- [ ] Service deployed successfully
- [ ] Noted backend Railway URL: `_______________________________`

## ☑️ Frontend Service Deployment

- [ ] Created UI service from GitHub repo
- [ ] Set Dockerfile path to `Dockerfile.frontend`
- [ ] Added environment variables:
  - [ ] `KRATOS_PUBLIC_URL` (use backend URL from above)
  - [ ] `KRATOS_BROWSER_URL` (temporary URL for now)
  - [ ] `COOKIE_SECRET=<your-32-char-secret>`
  - [ ] `CSRF_COOKIE_NAME=ory_csrf_ui`
  - [ ] `CSRF_COOKIE_SECRET=<your-32-char-secret>`
  - [ ] `PORT=3000` (optional)
- [ ] Enabled public networking
- [ ] Service deployed successfully
- [ ] Noted frontend Railway URL: `_______________________________`

## ☑️ Update Environment Variables

- [ ] Updated **backend** service:
  - [ ] `RAILWAY_PUBLIC_URL` = actual backend URL
  - [ ] `KRATOS_BROWSER_URL` = actual frontend URL
- [ ] Updated **frontend** service:
  - [ ] `KRATOS_PUBLIC_URL` = actual backend URL
  - [ ] `KRATOS_BROWSER_URL` = actual frontend URL
- [ ] Redeployed **both** services

## ☑️ Database Migration

- [ ] Opened backend service terminal/shell
- [ ] Ran: `kratos migrate sql -e --yes -c /etc/kratos/kratos.yml`
- [ ] Migration completed successfully
- [ ] No errors in logs

## ☑️ Testing

- [ ] Backend health check works:
  ```bash
  curl https://your-backend-url.up.railway.app/health/ready
  ```
- [ ] Frontend UI loads at: `https://your-frontend-url.up.railway.app`
- [ ] Registration flow works:
  - [ ] Can access `/registration` page
  - [ ] Can submit registration form
  - [ ] Verification email received in Mailtrap
- [ ] Login flow works:
  - [ ] Can access `/login` page
  - [ ] Can login with created account
  - [ ] Session persists (no immediate logout)
- [ ] Cookies are set correctly (check browser DevTools)

## ☑️ Verification

- [ ] No CORS errors in browser console
- [ ] No database connection errors in backend logs
- [ ] SMTP connection successful (check backend logs)
- [ ] Session cookies have correct domain
- [ ] Can logout successfully

## 🎯 Your Deployment URLs

**Backend API**: `https://__________________________________.up.railway.app`

**Frontend UI**: `https://__________________________________.up.railway.app`

**PostgreSQL**: Managed by Railway (internal)

**Mailtrap**: `https://mailtrap.io/inboxes/___________`

---

## 🚨 If Something Fails

Refer to the troubleshooting section in [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md#-troubleshooting)

Common issues:
1. Database connection → Check `DATABASE_URL` and run migrations
2. CORS errors → Verify `KRATOS_BROWSER_URL` matches frontend URL
3. Session not persisting → Check `COOKIE_DOMAIN` setting
4. Emails not sending → Verify `MAILTRAP_SMTP_URI` credentials

---

## ✅ Deployment Complete!

Once all items are checked, your Kratos deployment is live and functional! 🚀

**Next Steps:**
- Test all authentication flows
- Monitor Railway logs for any issues
- Consider security hardening for production (see deployment guide)
