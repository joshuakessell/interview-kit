---
name: deploy-vercel
description: Deploy and debug on Vercel fast during a timed build. Use for deploy, ship, production URL, vercel errors, env vars on Vercel, build failures, or checking production logs.
---

# Vercel Under Time Pressure

## Core commands

- First deploy: `vercel --prod --yes` (links the project non-interactively with defaults).
- Subsequent: push to main if git integration is linked, else `vercel --prod` again. CLI deploys are fine for an interview — skip configuring git integration unless it's free.
- Env vars: `vercel env add NAME production` then `vercel env pull .env.local` to sync local. Redeploy after adding — env changes don't apply to existing deployments.
- Logs when prod misbehaves: `vercel logs <deployment-url>` or `vercel inspect <url> --logs`.

## Fast diagnosis table

- Build passes locally, fails on Vercel → almost always a case-sensitive import path or a devDependency used at build time. Check the build log's first error only; ignore the cascade.
- 500 in prod, fine locally → missing env var. `vercel env ls` before reading any code.
- API route 404 in prod → file placed outside `app/` route conventions, or edge/node runtime mismatch.
- Type errors blocking a deploy at minute 110 → fix them properly if under 5 minutes; otherwise `typescript.ignoreBuildErrors` in next.config is an emergency lever. If pulled, NARRATE it as conscious debt, and note it in the README.

## MCP vs CLI

Prefer the CLI for deploys — it's leaner than holding the Vercel MCP's tool definitions in context all session. Connect the Vercel MCP only if the session needs repeated log/status queries, and say why (NARRATE: token tradeoff).
