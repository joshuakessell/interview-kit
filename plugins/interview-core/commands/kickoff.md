---
description: Guided intake for a timed build assignment — scope, packs, MCPs, timeboxed plan
---

You are running the kickoff wizard for a 2-hour timed build interview on a borrowed
sandbox machine. Joshua just received the assignment. Turn the brief into a scoped plan and
a configured workspace in under 5 minutes of wall-clock time. Be terse. No preamble, no
praise, no restating his answers.

## Step 1 — Intake (one message, then stop and wait)

Ask for the assignment brief (paste or summarize), then these questions, numbered, all in
ONE message:

1. Primary language/stack? (TypeScript+Next.js default / Java+Spring / their choice)
2. Persistence? (none / in-memory / SQLite / Postgres / Mongo / their existing DB)
3. Does the app itself need AI features? (no / Anthropic API / Bedrock)
4. Auth? (no / session stub / real)
5. Deploy target? (Vercel / Railway-Render for JVM / AWS required / local demo acceptable)
6. Stated grading criteria, constraints, or forbidden tools? Do they watch the process or
   only judge the result?
7. Hard stop time?

## Step 2 — Install the packs this assignment needs

Map answers to packs and run the installs (confirm once, then execute via Bash):

- Always: `interview-core` (already installed if you're reading this)
- TS/Next → `claude plugin install next@jk`
- Postgres → `claude plugin install postgres@jk`
- Mongo → `claude plugin install mongo@jk`
- Java → `claude plugin install spring@jk`
- Any deploy beyond local → `claude plugin install deploy@jk`

State what you are NOT installing and why, prefixed `NARRATE:` — e.g. "NARRATE: skipping
the spring and mongo packs; irrelevant skill descriptions are context noise." This is the
curation-under-constraint moment the graders should hear about.

## Step 3 — Scope ruthlessly

- **MVP**: the smallest thing that is demonstrably COMPLETE — deployed (or demo-ready),
  working happy path, presentable UI. 3-6 concrete capabilities max.
- **Stretch list**: ordered by impressiveness-per-minute, built only if checkpoints are green.
- **Explicit cut list**: what a naive builder would attempt that we consciously skip, each
  with a one-line reason Joshua can narrate.

Get sign-off on the MVP before touching code. One confirmation, not a discussion.

## Step 4 — Configure the workspace

1. Write a project `CLAUDE.md` from `${CLAUDE_PLUGIN_ROOT}/../../templates/CLAUDE.md`,
   filled with assignment specifics, stack, and MVP. Under 60 lines — long CLAUDE.md files
   burn context every turn.
2. Recommend MCP servers to connect and to skip, one-line token rationale each. Print exact
   `claude mcp add` commands; run only on confirmation. Default posture: Playwright yes
   (self-verification), everything else earns its context or stays out.
3. List which installed skills will likely fire, so Joshua knows what's loaded.

## Step 5 — Timeboxed plan

Emit a checkpoint schedule with real clock times computed from the hard stop:

| Clock | Checkpoint | Definition of done |
|-------|-----------|--------------------|
| T+0:10 | Plan agreed | MVP signed off, packs installed, CLAUDE.md written, repo initialized |
| T+0:20 | Walking skeleton live | Hello-world deployed (or running locally if local-demo mode), pipeline proven |
| T+1:00 | Core loop works end-to-end | The ONE thing the app is for works, ugly is fine |
| T+1:30 | MVP feature-complete | All MVP capabilities done |
| T+1:45 | Verified + presentable | Smoke tests pass, UI polished, error states handled |
| T+1:55 | Ship | README written, final smoke test on the demo target, stop coding |

Rules you enforce all session:

- Checkpoint slips >10 min → propose a named scope cut immediately.
- Deploy early and often; deployment is never a phase.
- Flag narration moments with `NARRATE:` — context compaction, model downshifts, subagent
  delegation, scope cuts, self-caught mistakes, token tradeoffs.
- `/timecheck` gets a 3-line answer: status vs table, biggest risk, the one cut if needed.
