#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"
SKILLS=(backlog story pair review)

MODE="symlink"
FORCE=0
PROJECT_DIR=""
TARGETS=()

usage() {
  cat <<'EOF'
Usage: ./install.sh [options] <target>...

Targets (global):
  antigravity   ~/.gemini/config/skills
  claude        ~/.claude/skills
  codex         ~/.agents/skills
  gemini        ~/.gemini/skills
  cursor        ~/.cursor/skills
  copilot       ~/.copilot/skills
  opencode      ~/.config/opencode/skills
  all           Install in all global targets above

Target (project-local):
  project       Install into <dir>/.agents/skills (use --dir <path>, default: current dir)

Options:
  --copy        Copy files instead of creating symlinks (default: symlink)
  --force       Overwrite existing skills at destination
  --dir <path>  Target project directory (only used with 'project')
  -h, --help    Show this help

Examples:
  ./install.sh antigravity
  ./install.sh antigravity claude codex
  ./install.sh project --dir ~/dev/my-app
  ./install.sh --copy claude
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy) MODE="copy"; shift ;;
    --force) FORCE=1; shift ;;
    --dir)
      [[ $# -lt 2 ]] && { echo "Error: --dir requires a path" >&2; exit 1; }
      PROJECT_DIR="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    antigravity|claude|codex|gemini|cursor|copilot|opencode|project|all)
      TARGETS+=("$1"); shift ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1 ;;
  esac
done

if [[ ${#TARGETS[@]} -eq 0 ]]; then
  usage
  exit 1
fi

install_to_dir() {
  local dest_root="$1"
  mkdir -p "$dest_root"

  for skill in "${SKILLS[@]}"; do
    local src="$SKILLS_SRC/$skill"
    local dst="$dest_root/$skill"

    if [[ -e "$dst" || -L "$dst" ]]; then
      if [[ $FORCE -eq 1 ]]; then
        rm -rf "$dst"
      else
        echo "  [skip] $dst already exists (use --force to replace)"
        continue
      fi
    fi

    if [[ "$MODE" == "symlink" ]]; then
      ln -s "$src" "$dst"
      echo "  [link] $dst -> $src"
    else
      cp -R "$src" "$dst"
      echo "  [copy] $dst"
    fi
  done
}

resolve_target() {
  case "$1" in
    antigravity) echo "$HOME/.gemini/config/skills" ;;
    claude)      echo "$HOME/.claude/skills" ;;
    codex)       echo "$HOME/.agents/skills" ;;
    gemini)      echo "$HOME/.gemini/skills" ;;
    cursor)      echo "$HOME/.cursor/skills" ;;
    copilot)     echo "$HOME/.copilot/skills" ;;
    opencode)    echo "$HOME/.config/opencode/skills" ;;
    project)     echo "${PROJECT_DIR:-$PWD}/.agents/skills" ;;
  esac
}

EXPANDED=()
for t in "${TARGETS[@]}"; do
  if [[ "$t" == "all" ]]; then
    EXPANDED+=(antigravity claude codex gemini cursor copilot opencode)
  else
    EXPANDED+=("$t")
  fi
done

for t in "${EXPANDED[@]}"; do
  dest="$(resolve_target "$t")"
  echo "Installing skills for '$t' ($dest):"
  install_to_dir "$dest"
done

echo "Done."
