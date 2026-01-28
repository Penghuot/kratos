# Ory Kratos Railway Deployment Files

This directory contains everything you need to deploy your forked Ory Kratos to Railway.

## 📁 Files Overview

| File | Purpose |
|------|---------|
| `Dockerfile.backend` | Builds Kratos backend from your fork |
| `Dockerfile.frontend` | Deploys Kratos selfservice UI |
| `kratos.yml` | Kratos configuration with Railway env vars |
| `identity.schema.json` | Email-based identity schema |
| `RAILWAY_DEPLOYMENT.md` | **📖 Complete step-by-step deployment guide** |
| `ENV_VARS_QUICK_REFERENCE.md` | Quick reference for environment variables |

## 🚀 Quick Start

1. **Read the full guide**: Open [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md)
2. **Push these files to your fork**: 
   ```bash
   git add Dockerfile.backend Dockerfile.frontend kratos.yml identity.schema.json
   git commit -m "Add Railway deployment configuration"
   git push origin main
   ```
3. **Follow deployment steps** in the guide

## 🎯 What Gets Deployed

- **Kratos Backend** (API server) - Port 4433 (public), 4434 (admin)
- **Kratos UI** (Selfservice interface) - Port 3000
- **PostgreSQL** (Railway managed database)

## ⚙️ Architecture

```
┌─────────────────────────────────────────────────┐
│                  Railway Project                 │
├─────────────────────────────────────────────────┤
│                                                  │
│  ┌─────────────────┐      ┌──────────────────┐ │
│  │  Kratos Backend │◄─────┤   PostgreSQL     │ │
│  │   (Port 4433)   │      │    Database      │ │
│  └────────▲────────┘      └──────────────────┘ │
│           │                                      │
│           │ API Calls                            │
│           │                                      │
│  ┌────────┴────────┐                            │
│  │   Kratos UI     │                            │
│  │   (Port 3000)   │                            │
│  └─────────────────┘                            │
│                                                  │
│  ┌─────────────────┐                            │
│  │    Mailtrap     │ (external)                 │
│  │  SMTP Sandbox   │                            │
│  └─────────────────┘                            │
└─────────────────────────────────────────────────┘
```

## 📋 Prerequisites

- ✅ Railway account
- ✅ GitHub account with access to your fork
- ✅ Mailtrap account (for email testing)
- ✅ Your forked repo: https://github.com/Penghuot/kratos.git

## 🔗 Important Links

- **Full Deployment Guide**: [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md)
- **Environment Variables**: [ENV_VARS_QUICK_REFERENCE.md](ENV_VARS_QUICK_REFERENCE.md)
- **Your Fork**: https://github.com/Penghuot/kratos.git
- **Railway**: https://railway.app
- **Ory Kratos Docs**: https://www.ory.sh/docs/kratos/

## ⚡ TL;DR Deployment Steps

1. Create Railway project
2. Add PostgreSQL database
3. Deploy backend service using `Dockerfile.backend`
4. Deploy frontend service using `Dockerfile.frontend`
5. Set environment variables (see quick reference)
6. Update URLs after services are deployed
7. Run database migrations
8. Test login flow

**For detailed instructions, see [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md)**

## 🆘 Need Help?

Check the Troubleshooting section in [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md#-troubleshooting)

## 📝 Notes

- This is a **DEV setup** using Mailtrap for emails
- Secrets are configured via environment variables
- Both services deploy from your GitHub fork
- Railway automatically builds using the Dockerfiles
- No manual building required

---

**Ready to deploy? Start with [RAILWAY_DEPLOYMENT.md](RAILWAY_DEPLOYMENT.md)** 🚀
