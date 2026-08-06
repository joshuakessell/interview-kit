# interview-kit

Cold-start environment for timed build interviews on a borrowed machine, packaged as a
Claude Code plugin marketplace with on-demand domain packs.

## Day-of (their machine, ~4 minutes)

```bash
curl -fsSL https://joshuakessell.com/kit | bash
# complete the auth checklist it prints
cd ~/interview && claude
/kickoff
```

`/kickoff` takes the assignment brief, scopes an MVP with an explicit cut list, installs
only the relevant packs, writes the project CLAUDE.md, recommends MCPs with token
rationale, and emits a checkpoint schedule. `/ship` deploys and smoke-tests prod.
`/timecheck` paces against the clock.

## Packs (marketplace name: jk)

| Pack | Install | Contents |
|------|---------|----------|
| interview-core | always (bootstrap does it) | /kickoff · /ship · /timecheck · rapid-scaffold · timeboxed-testing · frontend-design |
| next | `/plugin install next@jk` | App Router discipline, data patterns, caching pressure valves, env traps |
| postgres | `/plugin install postgres@jk` | Neon/Supabase/Docker provisioning, Drizzle wiring, Mongo-vs-Postgres talking points |
| mongo | `/plugin install mongo@jk` | Atlas M0 fast path, driver choice, embed-vs-reference, serverless connection caching |
| spring | `/plugin install spring@jk` | start.spring.io curl scaffold, entity/repo/controller slice, H2-first strategy, MockMvc |
| deploy | `/plugin install deploy@jk` | Vercel playbook, AWS/Bedrock disambiguation + Converse API, JVM via Railway/Render |

/kickoff installs these for you based on your answers — the table is the manual fallback.

## The night before (your machine)

1. Push this repo: `gh repo create joshuakessell/interview-kit --public --source=. --push`
   (public, so their sandbox can clone it without auth — which is also why NOTHING secret
   ever goes in here).
2. Short link — add to joshuakessell.com's vercel.json:
   ```json
   { "redirects": [{ "source": "/kit",
     "destination": "https://raw.githubusercontent.com/joshuakessell/interview-kit/main/bootstrap.sh",
     "permanent": false }] }
   ```
   Fallback one-liner if your site is down:
   `curl -fsSL https://raw.githubusercontent.com/joshuakessell/interview-kit/main/bootstrap.sh | bash`
3. Create free-tier accounts NOW so tomorrow is login-not-signup: **Neon**, **MongoDB
   Atlas**, **Railway**. Verify **Vercel**, **GitHub**, and your **Claude** login work from
   a browser. Put any API keys in your password manager, reachable from your phone.

## Cold-start rehearsal (do this tonight — it is the whole point)

Simulate their machine in a throwaway container — and run the bootstrap as a NON-ROOT user
with no sudo, which is the worst case you might meet:

```bash
docker run -it --rm ubuntu:24.04 bash
apt-get update && apt-get install -y curl ca-certificates git
useradd -m dev && su - dev            # now you are sudo-less, like the sandbox might be
curl -fsSL https://joshuakessell.com/kit | bash
```

Then run `claude`, complete the OAuth flow (it prints a URL — open it on your phone: that
IS the headless-auth drill), run `/kickoff` with a made-up assignment, and drive it to a
running hello-world. This one container session rehearses the Linux cold start, the
no-sudo toolchain, and the phone-as-second-screen auth flow all at once. Every rough edge
you hit here is one you won't hit at 10am.

## Layout

```
.claude-plugin/marketplace.json
plugins/{interview-core,next,postgres,mongo,spring,deploy}/
  .claude-plugin/plugin.json · commands/ · skills/
templates/CLAUDE.md · templates/settings.json
bootstrap.sh
```
