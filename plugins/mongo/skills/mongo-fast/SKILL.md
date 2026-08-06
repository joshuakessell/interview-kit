---
name: mongo-fast
description: Provision and wire MongoDB in minutes for a timed build. Use when the assignment needs MongoDB, Mongo, NoSQL, a document database, Atlas, or mongoose.
---

# MongoDB in a Timed Build

## Provisioning

1. **Atlas M0 free tier** — account pre-created the night before; today: login, create
   cluster (~2 min spin-up), database user, and under Network Access allow 0.0.0.0/0.
   NARRATE: "open network rule because this is a disposable interview sandbox — in
   production this is VPC peering or an IP allowlist." Copy the `mongodb+srv://` string.
2. **Docker, if present**: `docker run -d --name mongo -p 27017:27017 mongo:7`
   → `mongodb://localhost:27017/app`.

## Driver choice

- **Mongoose** when the app is CRUD over a few models — schema validation and defaults for
  free: `pnpm add mongoose`.
- **Native `mongodb` driver** when it's one or two collections and you want zero
  abstraction: `pnpm add mongodb`.

## The serverless gotcha that kills demos

On Vercel/serverless (and Next.js hot reload), construct the client ONCE and cache it
globally, or you'll exhaust Atlas connections mid-demo:

```ts
// src/lib/mongo.ts
import { MongoClient } from "mongodb";
const uri = process.env.MONGODB_URI!;
let client: MongoClient;
const g = globalThis as unknown as { _mongo?: MongoClient };
if (!g._mongo) g._mongo = new MongoClient(uri);
client = g._mongo;
export const db = client.db("app");
```

## Modeling rule of thumb

Embed what you read together (order + its line items); reference what grows without bound
or is shared (users, products). If you're building join-like aggregation pipelines in a
2-hour Mongo app, the data was relational — say that out loud if asked, it's the honest
senior answer.
