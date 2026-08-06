---
description: Deploy checkpoint — push, deploy to prod, smoke test the live URL
---

Run the ship sequence. Stop at the first failure and fix it before continuing.

1. `git status` — commit anything uncommitted with a conventional message.
2. Run the fastest verification available (typecheck + unit smoke; skip full suites if the
   clock is tight — say so out loud with a NARRATE: line).
3. Deploy to the target chosen at /kickoff (default: `vercel --prod` from the project root).
4. Fetch the production URL and verify the core loop actually works there — not localhost.
   If a browser MCP is connected, load the page and screenshot it; otherwise curl the
   critical routes and check responses.
5. Report: prod URL, what was verified, elapsed deploy time. Three lines max.

If this is the final ship (past T+1:45), also generate a README.md: what it does, stack,
how to run locally, how it deploys, and honest known limitations. Keep it under 50 lines —
interviewers read READMEs.
