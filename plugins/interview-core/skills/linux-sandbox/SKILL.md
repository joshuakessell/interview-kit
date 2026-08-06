---
name: linux-sandbox
description: Survive a borrowed Linux machine — no-sudo installs, headless auth, clipboard, ports, and verifying UI without a visible browser. Use on any Linux sandbox, when sudo fails, when there is no GUI browser, when auth flows need device codes, or when Mac commands like pbcopy or open are missing.
---

# Borrowed Linux Box Survival

First 30 seconds: `cat /etc/os-release` (what distro), `sudo -v` (do we have sudo?),
`echo $XDG_SESSION_TYPE` + `command -v firefox chromium google-chrome` (is there a GUI
browser?). Those three answers pick every path below.

## No-sudo toolchain (everything lands in $HOME)

- Claude Code: `curl -fsSL https://claude.ai/install.sh | bash` → `~/.local/bin`, no root.
- Node: nvm → `nvm install --lts`. Never `apt install nodejs` — needs sudo and ships stale.
- Global npm bins without sudo: `npm config set prefix ~/.npm-global` and put
  `~/.npm-global/bin` on PATH before any `npm i -g`.
- JDK: SDKMAN (`curl -s https://get.sdkman.io | bash` then `sdk install java`) — user-space.
- Docker present but "permission denied" on the socket → you're not in the docker group and
  can't fix that without root. Don't burn time; use hosted DBs (Neon/Atlas) instead.

## Auth without a GUI browser (phone is the second screen)

- `gh auth login` → choose device flow: it prints a one-time code, enter it at
  github.com/login/device on your phone. Rock solid.
- `vercel login` / `railway login` → both print a URL when they can't open a browser; open
  it on your phone. (Railway also has `railway login --browserless` — verify the flag the
  night before.)
- `claude` first run prints an auth URL the same way. Fallback if OAuth is blocked:
  `export ANTHROPIC_API_KEY=...` from your password manager — note this bills API credits
  rather than your subscription, so it's the backup, not the default. `claude setup-token`
  on your own machine the night before is worth checking as a third option.
- Neon/Atlas connection strings: if the sandbox has any browser, use it; if truly headless,
  create the DB from your phone and type the string carefully (or `curl` a private
  paste-bin you control). Never email yourself secrets on their machine.

## Seeing the UI when there's nothing to look at

Headless verification IS the demo skill:

- Playwright MCP runs headless Chromium — have Claude load `localhost:3000` or the prod
  URL, click through the core loop, and screenshot; Claude reads its own screenshots.
- One-off eyeball without MCP: `npx playwright screenshot --full-page <url> shot.png`.
- APIs: `curl -s <url> | head -40` beats guessing, every time.
- If a GUI browser exists, use it normally — but still let Claude screenshot-verify before
  calling anything done. NARRATE: "Claude is verifying its own UI; localhost-looks-fine is
  not a test."

## Mac-reflex translations

| Reflex | Linux |
|---|---|
| `pbcopy` / `pbpaste` | `xclip -selection clipboard` (X11) / `wl-copy` · `wl-paste` (Wayland); if neither exists, cat the file and copy from the terminal |
| `open .` / `open <url>` | `xdg-open` |
| `brew install` | user-space installers above; `apt` only if sudo exists |
| port 3000 stuck | `lsof -ti:3000 | xargs -r kill` (or `fuser -k 3000/tcp`) |
| watch a log | `tail -f`, `journalctl` only if systemd services are involved (they won't be) |

## tmux (only if it's already installed)

One layout, four keys: `tmux` → `Ctrl-b %` split → Claude Code left, dev server right →
`Ctrl-b o` to hop panes, `Ctrl-b z` to zoom one. Don't install it, don't configure it, and
don't miss it if absent — Claude Code runs dev servers as background tasks on its own.
