---
name: timeboxed-testing
description: Right-sized verification for a 2-hour build — what to test, what to skip, and how to prove the deployed app works. Use when writing tests, verifying, smoke testing, or deciding test coverage under time pressure.
---

# Testing When the Clock Is the Constraint

Graders want evidence of verification discipline, not coverage numbers. Budget: ~10 minutes
total across the session.

## The three-layer minimum

1. **Typecheck as the always-on gate** — `tsc --noEmit` (or the framework build) before every
   deploy. Free, catches the most per second.
2. **Unit tests only for real logic** — if the app has an algorithm, a parser, a price
   calculator: 3-5 Vitest cases on that module only. Zero tests for glue code, components
   that just render props, or framework behavior.
3. **One end-to-end proof against PRODUCTION** — after final deploy, verify the core loop on
   the live URL. Best: browser MCP loads the prod page, performs the core action,
   screenshots the result. Fallback: curl the critical API routes and assert on responses.

## Skip without guilt (and NARRATE the skip)

- Full Playwright suites, CI pipelines, coverage thresholds, mocking infrastructure,
  snapshot tests. Name-drop that these exist in your real projects; do not build them here.

## The move that impresses

After deploy, have Claude verify its own work: load the prod URL, exercise the feature,
report what it saw. Self-verification closes the loop that most candidates leave open —
"works on localhost" is where timed builds go to die.
