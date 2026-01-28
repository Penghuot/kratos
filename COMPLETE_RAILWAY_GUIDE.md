# COMPLETE RAILWAY DEPLOYMENT GUIDE - UPDATED
# All configurations corrected and verified
# Last updated: January 28, 2026

## ═══════════════════════════════════════════════════════════════════
## BACKEND SERVICE ENVIRONMENT VARIABLES
## ═══════════════════════════════════════════════════════════════════

### In Railway: Backend Service → Variables

DATABASE_URL=${{Postgres.DATABASE_URL}}
RAILWAY_PUBLIC_URL=https://kratos-backend-production.up.railway.app
KRATOS_BROWSER_URL=https://kratos-ui-production.up.railway.app
COOKIE_DOMAIN=.up.railway.app
MAILTRAP_SMTP_URI=smtp://YOUR_USERNAME:YOUR_PASSWORD@smtp.mailtrap.io:2525
SECRETS_COOKIE=WFlAZojiZD2XCDwYQBu+h7U8nIgabVLU
SECRETS_CIPHER=r47MgCzkrrf2iPZetPunZ012gcmvsqM0

## ═══════════════════════════════════════════════════════════════════
## FRONTEND SERVICE ENVIRONMENT VARIABLES
## ═══════════════════════════════════════════════════════════════════

### In Railway: Frontend Service → Variables

KRATOS_PUBLIC_URL=https://kratos-backend-production.up.railway.app
KRATOS_BROWSER_URL=https://kratos-ui-production.up.railway.app
COOKIE_SECRET=JN+QYafjMne3wDs4dITiHB+r3kWgqc2i
CSRF_COOKIE_NAME=ory_csrf_ui
CSRF_COOKIE_SECRET=MH1ZG/sspzugq1dLJT6XcR0MiHyqFrCJ
PORT=3000

## ═══════════════════════════════════════════════════════════════════
## STEP-BY-STEP DEPLOYMENT
## ═══════════════════════════════════════════════════════════════════

### Step 1: Get Mailtrap Credentials
1. Go to https://mailtrap.io/inboxes
2. Select your inbox → SMTP Settings
3. Copy username and password
4. Format: smtp://username:password@smtp.mailtrap.io:2525

### Step 2: Create Railway Project
1. Go to Railway → New Project → Empty Project
2. Name it: kratos-auth

### Step 3: Add PostgreSQL
1. Click + New → Database → PostgreSQL
2. Wait for it to provision
3. Note: DATABASE_URL is automatically available as ${{Postgres.DATABASE_URL}}

### Step 4: Deploy Backend Service
1. Click + New → GitHub Repo
2. Select: Penghuot/kratos
3. Branch: railway-deployment
4. Railway will detect and start building

#### Configure Backend:
1. Go to service → Settings → General
   - Service Name: kratos-backend
   - Root Directory: / (leave empty)

2. Settings → Build
   - Builder: Dockerfile
   - Dockerfile Path: Dockerfile.backend

3. Variables tab → Add all backend variables (see above)
   - Use temporary URLs initially: https://temp.up.railway.app
   - Replace with actual URLs after first deploy

4. Settings → Networking
   - Enable "Generate Domain"
   - Copy the domain (e.g., kratos-backend-production.up.railway.app)

5. Wait for deployment to complete
6. Check logs for: "✅ Migration check completed" and "Starting Kratos server..."

### Step 5: Deploy Frontend Service
1. Click + New → GitHub Repo
2. Select: Penghuot/kratos (same repo)
3. Branch: railway-deployment

#### Configure Frontend:
1. Settings → General
   - Service Name: kratos-ui
   - Root Directory: / (leave empty)

2. Settings → Build
   - Builder: Dockerfile
   - Dockerfile Path: Dockerfile.frontend

3. Variables tab → Add all frontend variables (see above)
   - KRATOS_PUBLIC_URL: Use backend domain from Step 4
   - KRATOS_BROWSER_URL: Use temp URL initially

4. Settings → Networking
   - Enable "Generate Domain"
   - Copy the domain (e.g., kratos-ui-production.up.railway.app)

5. Wait for deployment to complete

### Step 6: Update URLs with Real Domains
1. Go to Backend Service → Variables
   - Update RAILWAY_PUBLIC_URL with actual backend domain
   - Update KRATOS_BROWSER_URL with actual frontend domain

2. Go to Frontend Service → Variables
   - Update KRATOS_PUBLIC_URL with actual backend domain
   - Update KRATOS_BROWSER_URL with actual frontend domain

3. Both services will auto-redeploy

### Step 7: Verify Deployment

#### Test Backend:
```bash
curl https://kratos-backend-production.up.railway.app/health/ready
# Should return: {"status":"ok"}

curl -I https://kratos-backend-production.up.railway.app/self-service/registration/browser
# Should return: 303 redirect to frontend with flow parameter
```

#### Test Frontend:
```bash
# Visit in browser:
https://kratos-ui-production.up.railway.app/

# Should show: Kratos UI homepage with Sign In / Sign Up links
```

#### Test Complete Flow:
1. Visit: https://kratos-ui-production.up.railway.app/
2. Click "Sign Up" or "Create Account"
3. Should see registration form with email/password fields
4. Fill form and submit
5. Check Mailtrap for verification email
6. Should be able to login after verification

## ═══════════════════════════════════════════════════════════════════
## TROUBLESHOOTING
## ═══════════════════════════════════════════════════════════════════

### Backend Returns 502
**Problem**: Kratos not listening on correct port
**Solution**: 
- Check backend logs for "Starting Kratos server..."
- Verify PORT environment variable is being used
- Backend should show: "Public API will be available on port ${PORT}"

### Frontend Shows 404
**Problem**: Frontend can't connect to backend
**Solution**:
- Verify KRATOS_PUBLIC_URL in frontend matches backend domain EXACTLY
- Check frontend logs for "KRATOS_PUBLIC_URL=..."
- Remove any quotes from environment variables in Railway
- Ensure both services are in same Railway project

### CORS Errors
**Problem**: Backend blocking frontend requests
**Solution**:
- Verify KRATOS_BROWSER_URL in backend matches frontend domain
- Check backend logs when frontend makes request
- Ensure no trailing slashes in URLs

### "dsn must be set"
**Problem**: Database URL not being transformed
**Solution**:
- Check backend logs show "DSN configured for Kratos"
- Verify DATABASE_URL is set to ${{Postgres.DATABASE_URL}}
- Ensure entrypoint.sh is transforming postgresql:// to postgres://

### Sessions Not Persisting
**Problem**: Cookie domain misconfigured
**Solution**:
- Verify COOKIE_DOMAIN=.up.railway.app in backend
- Check browser cookies (DevTools → Application → Cookies)
- Cookies should have domain: .up.railway.app

### Email Not Sending
**Problem**: SMTP credentials incorrect
**Solution**:
- Verify MAILTRAP_SMTP_URI format: smtp://user:pass@smtp.mailtrap.io:2525
- No spaces, no quotes, starts with smtp:// (not smtps://)
- Check backend logs for SMTP connection errors
- Test credentials in Mailtrap dashboard

## ═══════════════════════════════════════════════════════════════════
## EXPECTED LOG OUTPUT
## ═══════════════════════════════════════════════════════════════════

### Backend Startup:
```
====================================
Ory Kratos Startup Script
====================================
✅ DATABASE_URL is set
✅ DSN configured for Kratos
Environment variables for Kratos:
  RAILWAY_PUBLIC_URL=https://kratos-backend-production.up.railway.app
  KRATOS_BROWSER_URL=https://kratos-ui-production.up.railway.app
Substituting environment variables in config...
Checking substitution (registration ui_url):
      ui_url: https://kratos-ui-production.up.railway.app/registration

Running database migrations...
(Skipping if already applied)
⚠️  Migration command exited with error, but continuing...
This is normal if migrations are already applied

✅ Migration check completed

Starting Kratos server...
====================================
```

### Frontend Startup:
```
> kratos-selfservice-ui-node@0.10.1 start
> node lib/index.js

Kratos UI listening on http://0.0.0.0:3000
Using KRATOS_PUBLIC_URL: https://kratos-backend-production.up.railway.app
```

## ═══════════════════════════════════════════════════════════════════
## QUICK VERIFICATION CHECKLIST
## ═══════════════════════════════════════════════════════════════════

- [ ] PostgreSQL database created in Railway
- [ ] Backend service deployed from railway-deployment branch
- [ ] Backend using Dockerfile.backend
- [ ] Backend has all 7 environment variables set
- [ ] Backend shows "✅ Migration check completed" in logs
- [ ] Backend /health/ready returns {"status":"ok"}
- [ ] Frontend service deployed from railway-deployment branch  
- [ ] Frontend using Dockerfile.frontend
- [ ] Frontend has all 6 environment variables set
- [ ] Frontend logs show "Using KRATOS_PUBLIC_URL: ..."
- [ ] Frontend homepage loads at https://kratos-ui-production.up.railway.app/
- [ ] Clicking "Sign Up" shows registration form (not 404)
- [ ] Can register new account
- [ ] Verification email received in Mailtrap
- [ ] Can login after verification
- [ ] Session persists across page reloads

## ═══════════════════════════════════════════════════════════════════
## ARCHITECTURE DIAGRAM
## ═══════════════════════════════════════════════════════════════════

```
┌─────────────────────────────────────────────────────────────┐
│                     Railway Project                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────┐                                   │
│  │   PostgreSQL DB      │                                   │
│  │   (Managed Plugin)   │                                   │
│  └──────────▲───────────┘                                   │
│             │                                                │
│             │ DATABASE_URL                                   │
│             │                                                │
│  ┌──────────┴───────────┐        ┌──────────────────────┐  │
│  │  Kratos Backend      │◄───────┤  Kratos Frontend     │  │
│  │  (Dockerfile.backend)│  API   │  (Dockerfile.frontend)│  │
│  │                      │        │                      │  │
│  │  Port: ${PORT}       │        │  Port: 3000          │  │
│  │  (Railway assigned)  │        │                      │  │
│  └──────────────────────┘        └──────────────────────┘  │
│           │                                 │                │
│           │ HTTPS (Railway Proxy)           │                │
│           ▼                                 ▼                │
│  kratos-backend-production      kratos-ui-production        │
│     .up.railway.app                .up.railway.app          │
│                                                              │
│  ┌──────────────────────┐                                   │
│  │   Mailtrap SMTP      │  (External Service)               │
│  │   smtp.mailtrap.io   │                                   │
│  └──────────────────────┘                                   │
└─────────────────────────────────────────────────────────────┘
```

## ═══════════════════════════════════════════════════════════════════
## FILES IN DEPLOYMENT
## ═══════════════════════════════════════════════════════════════════

- Dockerfile.backend     → Builds Kratos backend from official image
- Dockerfile.frontend    → Runs Kratos UI from official image
- kratos.yml            → Kratos configuration (env vars substituted)
- identity.schema.json  → Email/password identity schema
- entrypoint.sh         → Startup script (migrations + server)

## ═══════════════════════════════════════════════════════════════════
## SUCCESS INDICATORS
## ═══════════════════════════════════════════════════════════════════

✅ Backend health check returns 200 OK
✅ Frontend homepage loads
✅ Registration form displays
✅ Can create account
✅ Email received in Mailtrap
✅ Can verify email
✅ Can login
✅ Session cookie set with correct domain
✅ Can logout
✅ No CORS errors in browser console

Your Kratos deployment is now complete and production-ready! 🎉
