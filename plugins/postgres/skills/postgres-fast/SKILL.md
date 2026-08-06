---
name: postgres-fast
description: Provision and wire a Postgres database in minutes for a timed build, including Drizzle setup and Mongo-vs-Postgres interview talking points. Use when the assignment needs Postgres, SQL, a relational database, Drizzle, Neon, or Supabase, or when comparing SQL vs NoSQL.
---

# Postgres in a Timed Build

## Provisioning, ranked by cold-start speed

1. **Neon** — signup to connection string in ~2 minutes, serverless, free tier, no card.
   Best default on a machine you don't control. (Account created the night before; today
   is login, new project, copy `DATABASE_URL`.)
2. **Supabase** — comparable speed; brings auth/storage/realtime you probably won't use.
   Pick it if the assignment wants any of those extras.
3. **Docker, if present**: `docker run -d --name pg -p 5432:5432 -e POSTGRES_PASSWORD=pg postgres:16`
   → `postgresql://postgres:pg@localhost:5432/postgres`. Zero network dependency, but dies
   with the machine — fine for a demo, say so.
4. **SQLite pivot** — if provisioning stalls >10 min and persistence isn't itself graded,
   swap to better-sqlite3/libsql and NARRATE the tradeoff. Working beats architecturally pure.

## Wiring (TypeScript, Drizzle)

```bash
pnpm add drizzle-orm pg && pnpm add -D drizzle-kit @types/pg
# Neon serverless driver instead of pg when deploying to Vercel edge/serverless:
# pnpm add @neondatabase/serverless
```

```ts
// src/db/schema.ts
import { pgTable, uuid, text, timestamp } from "drizzle-orm/pg-core";
export const items = pgTable("items", {
  id: uuid("id").defaultRandom().primaryKey(),
  title: text("title").notNull(),
  createdAt: timestamp("created_at").defaultNow().notNull(),
});
```

Schema sync: `pnpm drizzle-kit push` — direct push, no migration files. Migration ceremony
is for teams and time; an interview has neither. NARRATE that choice.

Speed rules: `uuid` PKs with `defaultRandom()`, `created_at` on every table, typed queries
only (no raw SQL), no indexes until a query is provably slow — which it won't be at demo scale.

## Mongo vs Postgres — the crisp answer (they asked this in round one)

- **Postgres**: relational model, enforced schema, ACID transactions, joins and rich
  aggregation. JSONB columns give document-style flexibility inside the relational model.
  Scales via read replicas and partitioning.
- **Mongo**: document model, flexible schema, nested heterogeneous data feels native,
  designed-in horizontal sharding. Multi-document transactions exist but aren't the idiom.
- **Decision axes**: stability of data shape, need for cross-entity integrity, query
  complexity, team fluency. The senior take: "Postgres with JSONB covers most document use
  cases, so I default to Postgres unless the access pattern is genuinely document-first —
  then Mongo earns its place."
