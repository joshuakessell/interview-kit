#!/usr/bin/env bash
# Cold-start bootstrap for a borrowed sandbox machine (Linux or macOS, open internet).
# Usage:  curl -fsSL https://joshuakessell.com/kit | bash
# Flags:  SKIP_NODE=1  don't auto-install Node when missing (e.g. pure Java assignment)
# Assumes nothing: no sudo, no Node, no git, no GUI. Everything installs to $HOME.
set -euo pipefail

REPO="joshuakessell/interview-kit"
KIT_DIR="$HOME/.interview-kit"
WORKSPACE="$HOME/interview"

say()  { printf '\n\033[1;36m▸ %s\033[0m\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

# sudo-free global npm installs: fall back to a user prefix on EACCES
npm_g() {
  npm install -g "$@" 2>/dev/null && return 0
  npm config set prefix "$HOME/.npm-global"
  export PATH="$HOME/.npm-global/bin:$PATH"
  npm install -g "$@"
}

# ---------------------------------------------------------------- environment recon
say "Environment"
[ -f /etc/os-release ] && . /etc/os-release && echo "  distro: ${PRETTY_NAME:-unknown}" || echo "  os: $(uname -s)"
if sudo -n true 2>/dev/null; then echo "  sudo: yes"; else echo "  sudo: no (fine — everything below is user-space)"; fi
if have firefox || have chromium || have chromium-browser || have google-chrome; then
  echo "  gui browser: yes (normal OAuth flows)"
else
  echo "  gui browser: NO — use device-code/URL auth flows; your phone is the second screen"
fi

# ---------------------------------------------------------------- claude code (no Node needed)
if ! have claude; then
  say "Installing Claude Code (native installer)"
  curl -fsSL https://claude.ai/install.sh | bash
  export PATH="$HOME/.local/bin:$PATH"
fi
have claude || { echo "claude not on PATH — open a new terminal and rerun"; exit 1; }
say "Claude Code: $(claude --version 2>/dev/null || echo installed)"

# ---------------------------------------------------------------- node (user-space via nvm)
if ! have node && [ "${SKIP_NODE:-0}" != "1" ]; then
  say "Installing Node LTS via nvm (user-space, no sudo)"
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  # shellcheck disable=SC1091
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm install --lts >/dev/null
fi

# ---------------------------------------------------------------- get the kit
say "Fetching interview kit"
if have git; then
  if [ -d "$KIT_DIR/.git" ]; then git -C "$KIT_DIR" pull --ff-only
  else git clone --depth 1 "https://github.com/$REPO.git" "$KIT_DIR"; fi
else
  mkdir -p "$KIT_DIR"
  curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/heads/main" \
    | tar -xz -C "$KIT_DIR" --strip-components=1
  echo "  (no git on this box — kit fetched as tarball; install git before scaffolding)"
fi

# ---------------------------------------------------------------- workspace
say "Creating workspace at $WORKSPACE"
mkdir -p "$WORKSPACE/.claude"
[ -f "$WORKSPACE/.claude/settings.json" ] || cp "$KIT_DIR/templates/settings.json" "$WORKSPACE/.claude/settings.json"
[ -f "$WORKSPACE/CLAUDE.md.template" ]    || cp "$KIT_DIR/templates/CLAUDE.md" "$WORKSPACE/CLAUDE.md.template"

# ---------------------------------------------------------------- plugins
say "Registering marketplace + installing interview-core (domain packs come later via /kickoff)"
claude plugin marketplace add "$KIT_DIR" 2>/dev/null \
  || claude plugin marketplace update jk 2>/dev/null \
  || echo "  Fallback — run inside Claude Code:  /plugin marketplace add $REPO"
claude plugin install interview-core@jk 2>/dev/null \
  || echo "  Fallback — run inside Claude Code:  /plugin install interview-core@jk"
claude plugin marketplace add anthropics/skills 2>/dev/null || true

# ---------------------------------------------------------------- node-dependent tooling
if have node; then
  have pnpm   || { npm_g pnpm   >/dev/null 2>&1 && echo "  + pnpm"; }
  have vercel || { npm_g vercel >/dev/null 2>&1 && echo "  + vercel CLI"; }
  claude mcp add playwright -- npx -y @playwright/mcp@latest 2>/dev/null \
    && echo "  + Playwright MCP (headless browser = Claude's eyes on the UI)" || true
fi

# ---------------------------------------------------------------- inventory
say "Sandbox inventory"
for t in git node pnpm java docker tmux gh vercel psql mongosh xclip wl-copy; do
  if have "$t"; then printf '  ✔ %-8s %s\n' "$t" "$($t --version 2>/dev/null | head -1 | cut -c1-45)"
  else printf '  ✘ %-8s missing\n' "$t"; fi
done
have java || echo "  Java assignment? user-space JDK: curl -s https://get.sdkman.io | bash && sdk install java"
if have docker && ! docker info >/dev/null 2>&1; then
  echo "  docker exists but socket denied (no group membership) — use hosted DBs (Neon/Atlas) instead"
fi

# ---------------------------------------------------------------- checklists
say "AUTH — in order (no GUI browser? every one of these has a URL/device-code flow — use your phone)"
cat <<'AUTH'
  1. claude                → OAuth URL, open wherever you have a browser
  2. gh auth login          → device flow: one-time code at github.com/login/device
  3. vercel login           → prints URL when it can't open a browser
  4. Neon / Atlas / Railway → browser logins (accounts created LAST NIGHT — login, not signup)
  Secrets stay in your password manager on your phone. Never in this repo, never in git.
AUTH

say "Then:"
cat <<'STEPS'
  cd ~/interview
  claude
  /kickoff     ← paste the assignment; it scopes the MVP, installs the right packs, plans the clock
  /ship        ← deploy checkpoints        /timecheck ← pacing
STEPS
