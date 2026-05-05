#!/usr/bin/env bash
set -euo pipefail

# AI-PLC Installer for Codex
# Installs AI-PLC pipeline skills and project guidance into a Codex project.
# Usage: ./install-codex.sh [--dry-run] [--target /path/to/project]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION="$(cat "$SCRIPT_DIR/.ai-plc-version" 2>/dev/null || echo "unknown")"
DRY_RUN=false
TARGET_DIR=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        --target) TARGET_DIR="$2"; shift 2 ;;
        -h|--help)
            echo "AI-PLC Installer for Codex v${VERSION}"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --dry-run          Show what would be done without making changes"
            echo "  --target PATH      Install to specified project directory"
            echo "  -h, --help         Show this help message"
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

if [[ -z "$TARGET_DIR" ]]; then
    TARGET_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
fi

BACKUP_SUFFIX=".bak.$(date +%Y%m%d)"

info()  { echo "  ✅ $1"; }
warn()  { echo "  ⚠️  $1"; }
skip()  { echo "  ⏭️  $1 (already exists, skipping)"; }
dry()   { echo "  🔍 [dry-run] $1"; }

install_skills_without_deprecated() {
    local src="$1" dst="$2"
    if [[ "$DRY_RUN" == true ]]; then
        dry "copy directory $src → $dst (excluding deprecated db-sync)"
        return
    fi
    mkdir -p "$dst"
    cp -r "$src"/* "$dst"/ 2>/dev/null || true
    rm -rf "$dst/ai-plc/db-sync"
}

safe_copy_if_missing() {
    local src="$1" dst="$2"
    if [[ -f "$dst" ]]; then
        skip "$dst"
        return
    fi
    if [[ "$DRY_RUN" == true ]]; then
        dry "copy $src → $dst (new)"
        return
    fi
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    info "Created: $dst"
}

merge_with_markers() {
    local template="$1" target="$2" marker_start="<!-- AI-PLC START -->" marker_end="<!-- AI-PLC END -->"

    if [[ "$DRY_RUN" == true ]]; then
        if [[ -f "$target" ]]; then
            dry "merge AI-PLC section into existing $target"
        else
            dry "create $target from template"
        fi
        return
    fi

    if [[ ! -f "$target" ]]; then
        cp "$template" "$target"
        info "Created: $target"
        return
    fi

    cp "$target" "${target}${BACKUP_SUFFIX}"
    warn "Backed up existing: ${target}${BACKUP_SUFFIX}"

    if grep -q "$marker_start" "$target" 2>/dev/null; then
        local tmp
        tmp="$(mktemp)"
        awk -v start="$marker_start" -v end="$marker_end" -v tpl="$template" '
            BEGIN { skip=0 }
            $0 ~ start { skip=1; while((getline line < tpl) > 0) print line; next }
            $0 ~ end { skip=0; next }
            skip==0 { print }
        ' "$target" > "$tmp"
        mv "$tmp" "$target"
        info "Updated AI-PLC section in: $target"
    else
        echo "" >> "$target"
        cat "$template" >> "$target"
        info "Appended AI-PLC section to: $target"
    fi
}

echo ""
echo "🚀 AI-PLC Installer for Codex v${VERSION}"
echo "   Target: $TARGET_DIR"
if [[ "$DRY_RUN" == true ]]; then
    echo "   Mode: DRY RUN (no changes will be made)"
fi
echo ""

echo "📦 Step 1/4: Installing skills..."
install_skills_without_deprecated "$SCRIPT_DIR/core/skills" "$TARGET_DIR/.codex/skills"
info "Skills installed: .codex/skills/ai-plc/"

echo ""
echo "📝 Step 2/4: Merging AGENTS.md..."
merge_with_markers "$SCRIPT_DIR/claude/AGENTS.md.template" "$TARGET_DIR/AGENTS.md"

echo ""
echo "🧠 Step 3/4: Installing templates (skip if exists)..."
safe_copy_if_missing "$SCRIPT_DIR/templates/soul.md" "$TARGET_DIR/.codex/soul.md"
safe_copy_if_missing "$SCRIPT_DIR/templates/user.md" "$TARGET_DIR/.codex/user.md"
safe_copy_if_missing "$SCRIPT_DIR/templates/memory.md" "$TARGET_DIR/.codex/memory.md"
if [[ "$DRY_RUN" == true ]]; then
    dry "create directory $TARGET_DIR/.codex/wiki"
else
    mkdir -p "$TARGET_DIR/.codex/wiki"
fi
safe_copy_if_missing "$SCRIPT_DIR/templates/wiki/index.md" "$TARGET_DIR/.codex/wiki/index.md"
safe_copy_if_missing "$SCRIPT_DIR/templates/wiki/log.md" "$TARGET_DIR/.codex/wiki/log.md"

echo ""
echo "📌 Step 4/4: Version marker..."
if [[ "$DRY_RUN" != true ]]; then
    cp "$SCRIPT_DIR/.ai-plc-version" "$TARGET_DIR/.ai-plc-version"
fi
info "Version: $VERSION"

echo ""
echo "✨ AI-PLC for Codex installed successfully!"
echo "   Version: $VERSION"
echo ""
echo "Next steps:"
echo "  1. Edit .codex/soul.md with your AI identity"
echo "  2. Edit .codex/user.md with your profile"
echo "  3. Start Codex in this project root so AGENTS.md is in scope"
echo "  4. Invoke the pipeline skill, e.g. ai-plc/01-collection"
echo ""
