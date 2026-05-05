# Migration Note: Remove Mandatory Notion Dependency

## 概要

この変更では、AI-PLC の運用前提を **Notion中心** から **Local-first** に移行した。

現在は、`intent.yaml` / `backlog.yaml` / `context.yaml` / `Documents/` / `{{agent_home}}/wiki/` を正本として扱う。

外部システム連携は `sync_targets` を明示設定した場合のみ有効で、未設定時の既定値は `sync_targets: []` である。

## 目的

- Notion がなくても AI-PLC を利用できるようにする
- 実体のない Notion 前提ルールと実際のローカル運用を一致させる
- 外部連携を「必須依存」ではなく「任意アダプタ」に降格する

## 何が変わったか

### 1. 実装成果物の定義

- 変更前: 実装系タスクは Notion 機能で実装する前提
- 変更後: 実装系タスクは具体的な成果物として実装する
- 例: コード変更、設定反映、ファイル生成、必要に応じた外部システム更新

### 2. 永続メモリの正本

- `{{agent_home}}` は利用中ツールのローカル作業ディレクトリを表す
- 例:
  - Claude Code: `.claude`
  - Cursor: `.cursor`
  - Codex: `.codex`

- 変更前: `.notion` 配下や Notion ページ参照が前提
- 変更後:
  - `{{agent_home}}/memory.md`
  - `{{agent_home}}/user.md`
  - `{{agent_home}}/soul.md`
  - `{{agent_home}}/wiki/`

### 3. External Sync の既定動作

- 変更前: `sync_targets` 未設定時でも Notion DB を自動適用する想定
- 変更後: `sync_targets: []` を既定値とし、自動同期しない
- 同期先は SQLite / Linear / GitHub Issues / CSV などを明示設定して利用

### 4. Knowledge Lint / Wiki 運用

- 変更前: `.notion/wiki/` を対象に運用
- 変更後: `{{agent_home}}/wiki/` を対象に運用
- 月次 Lint は cron / Task Runner などのローカル実行を前提とする

### 5. Project Registry

- 変更前: Notion Projects DB 更新が完了処理に含まれていた
- 変更後: ローカル Project Registry を前提にし、例として `{{agent_home}}/db/ai_plc.db` を想定

## 影響範囲

- `core/rules/ai-plc-system.md`
- `core/rules/ai-plc-adaptive.md`
- `core/skills/ai-plc/01-collection/SKILL.md`
- `core/skills/ai-plc/02-inception/SKILL.md`
- `core/skills/ai-plc/03-construction/SKILL.md`
- `core/skills/ai-plc/04-operation/SKILL.md`
- `core/skills/ai-plc/db-sync/SKILL.md`
- `core/skills/ai-plc/templates/*`
- `README.md`
- `docs/ARCHITECTURE.md`
- `claude/CLAUDE.md.template`
- `claude/AGENTS.md.template`
- `cursor/rules/ai-plc-system.mdc`

## 既存ユーザー向けチェックリスト

### 必須

- `sync_targets` を Notion 前提で自動投入している運用がないか確認する
- `{{agent_home}}/wiki/` が存在することを確認する
- 運用上の「完了条件」が Notion 更新を必須にしていないか確認する

### 必要に応じて

- 外部同期が必要なら `intent.yaml` に `sync_targets` を明示設定する
- Project Registry を使う場合はローカル SQLite か別の外部台帳を定義する
- 既存の Notion 手順書がある場合は Local-first 運用に読み替える

## 非互換ポイント

- `sync_targets` 未設定時に Notion DB へ同期される前提は廃止
- `.notion/wiki/` を参照するルールは廃止
- 「Notion で作れば完了」という定義は廃止

## 現在の推奨運用

1. `backlog.yaml` でタスク状態を管理する
2. `Documents/` に成果物を保存する
3. `context.yaml` と `Context/` で実行コンテキストを保持する
4. `{{agent_home}}/wiki/` に知見を蓄積する
5. 外部連携が必要な場合のみ `sync_targets` を設定する

## 補足

- `core/skills/ai-plc/db-sync/SKILL.md` は deprecated 扱いで repo 内にのみ残し、標準インストール対象から除外した
- 理由は `{{agent_home}}/db/sync.py` 実装が同梱されておらず、利用側依存が大きいため
- 将来的には `db-sync` の命名も `external-sync` 系へ寄せる余地がある
