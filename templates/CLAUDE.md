# {{PROJECT_NAME}}

{{ONE_SENTENCE_DESCRIPTION}}

## Assignment scope (agreed at kickoff)

MVP — build exactly this, nothing more:
{{MVP_BULLETS}}

Explicitly out of scope: {{CUT_LIST}}

Hard stop: {{HARD_STOP_TIME}}. Checkpoints: skeleton deployed by {{T20}}, core loop live by
{{T60}}, feature-complete by {{T90}}, ship by {{T115}}.

## Stack

{{STACK_LINE}} — deployed to {{DEPLOY_TARGET}}.

## Working rules

- Deploy after every meaningful change; production is the source of truth, not localhost.
- Typecheck before every deploy. Unit tests only on real logic modules.
- No `as any`, no `as unknown as T`. Handle error states in UI, not just happy paths.
- Prefer boring defaults over configuration. No speculative dependencies.
- If a checkpoint slips >10 min, propose a scope cut before writing more code.
- Prefix noteworthy decisions with `NARRATE:` (scope cuts, token/context moves, model
  choices, self-caught mistakes) so Joshua can voice them to the interviewer.

## Commands

- Dev: `pnpm dev` · Typecheck: `pnpm tsc --noEmit` · Test: `pnpm vitest run`
- Deploy: `vercel --prod` · Prod logs: `vercel logs <url>`
