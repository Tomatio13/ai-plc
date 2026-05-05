#!/usr/bin/env bash
set -euo pipefail

# AI-PLC Installer for Cursor
# Installs AI-PLC pipeline skills and rules into a Cursor project.
# Usage: ./install-cursor.sh [--dry-run] [--target /path/to/project]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION="$(cat "$SCRIPT_DIR/.ai-plc-version" 2>/dev/null || echo "unknown")"
DRY_RUN=false
TARGET_DIR=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        --target) TARGET_DIR="$2"; shift 2 ;;
        -h|--help)
            echo "AI-PLC Installer for Cursor v${VERSION}"
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

safe_copy() {
    local src="$1" dst="$2"
    if [[ "$DRY_RUN" == true ]]; then
        dry "copy $src → $dst"
        return
    fi
    if [[ -f "$dst" ]]; then
        cp "$dst" "${dst}${BACKUP_SUFFIX}"
        warn "Backed up existing: ${dst}${BACKUP_SUFFIX}"
    fi
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
}

safe_copy_dir() {
    local src="$1" dst="$2"
    if [[ "$DRY_RUN" == true ]]; then
        dry "copy directory $src → $dst"
        return
    fi
    mkdir -p "$dst"
    cp -r "$src"/* "$dst"/ 2>/dev/null || true
}

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

echo ""
echo "🚀 AI-PLC Installer for Cursor v${VERSION}"
echo "   Target: $TARGET_DIR"
if [[ "$DRY_RUN" == true ]]; then
    echo "   Mode: DRY RUN (no changes will be made)"
fi
echo ""

echo "📦 Step 1/4: Installing skills..."
install_skills_without_deprecated "$SCRIPT_DIR/core/skills" "$TARGET_DIR/.cursor/skills"
info "Skills installed: .cursor/skills/ai-plc/"

echo ""
echo "📏 Step 2/4: Installing rules (.mdc format)..."
for rule in "$SCRIPT_DIR"/cursor/rules/ai-plc-*.mdc; do
    fname="$(basename "$rule")"
    safe_copy "$rule" "$TARGET_DIR/.cursor/rules/$fname"
done
info "Rules installed: .cursor/rules/ai-plc-*.mdc"

echo ""
echo "🧠 Step 3/4: Installing templates (skip if exists)..."
safe_copy_if_missing "$SCRIPT_DIR/templates/soul.md" "$TARGET_DIR/.cursor/soul.md"
safe_copy_if_missing "$SCRIPT_DIR/templates/user.md" "$TARGET_DIR/.cursor/user.md"
safe_copy_if_missing "$SCRIPT_DIR/templates/memory.md" "$TARGET_DIR/.cursor/memory.md"
if [[ "$DRY_RUN" == true ]]; then
    dry "create directory $TARGET_DIR/.cursor/wiki"
else
    mkdir -p "$TARGET_DIR/.cursor/wiki"
fi
safe_copy_if_missing "$SCRIPT_DIR/templates/wiki/index.md" "$TARGET_DIR/.cursor/wiki/index.md"
safe_copy_if_missing "$SCRIPT_DIR/templates/wiki/log.md" "$TARGET_DIR/.cursor/wiki/log.md"

echo ""
echo "📌 Step 4/4: Version marker..."
if [[ "$DRY_RUN" != true ]]; then
    cp "$SCRIPT_DIR/.ai-plc-version" "$TARGET_DIR/.ai-plc-version"
fi
info "Version: $VERSION"

echo ""
echo "✨ AI-PLC for Cursor installed successfully!"
echo "   Version: $VERSION"
echo ""
echo "Next steps:"
echo "  1. Skills are at: .cursor/skills/ai-plc/"
echo "  2. Rules are at: .cursor/rules/ai-plc-*.mdc"
echo "  3. Persistent knowledge lives in .cursor/wiki/ and related local markdown files"
echo "  4. Use @01-collection to start your first pipeline"
echo ""
