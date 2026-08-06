---
name: rapid-scaffold
description: Scaffold a deployable web app skeleton in under 10 minutes for a timed build. Use when starting a new project under time pressure, when the user says kickoff, scaffold, new app, walking skeleton, or get something deployed fast.
---

# Rapid Scaffold

Goal: a deployed hello-world at a public URL by minute 20. Everything else is negotiable.

## Default stack (deviate only if the assignment forces it)

- Next.js (App Router) + TypeScript + Tailwind. `pnpm create next-app@latest <name> --ts --tailwind --app --src-dir --no-eslint --use-pnpm --yes`
- shadcn/ui only if the UI needs real components: `pnpm dlx shadcn@latest init -d` then add components on demand, never all at once.
- If the assignment is API-only or realtime-heavy, Joshua's Fastify + Drizzle patterns are fair game — but Next.js API routes cover 90% of 2-hour assignments with zero extra deploy config.

## Sequence

1. Scaffold, `git init`, first commit immediately.
2. `gh repo create <name> --private --source=. --push` (private unless told otherwise).
3. Deploy the untouched skeleton NOW: `vercel --prod --yes`. Confirm the URL loads before writing any feature code. This proves the entire pipeline while stakes are zero.
4. Env vars: add via `vercel env add` the moment a secret exists. Never hardcode; never discover a missing env var at minute 100.

## Anti-patterns under time pressure

- Do not hand-roll config (eslint flat configs, custom webpack, monorepo tooling). Defaults ship.
- Do not add a database before the core loop works with in-memory state, unless persistence IS the assignment.
- Do not install a component library, an ORM, and an auth provider speculatively. Each addition must be pulled in by a task on the MVP list.
- SQLite/in-memory beats Postgres when the grader only sees a 2-hour demo. Say the tradeoff out loud (NARRATE:) rather than silently under-engineering.
