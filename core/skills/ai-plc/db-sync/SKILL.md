---
name: db-sync
description: Synchronize AI-PLC local task or project state with an external system when a project-specific sync engine is available. Use only when explicit sync_targets exist and the user asks to push, pull, inspect, or reconcile external task data.
compatibility: Requires a project-specific sync implementation and local database files. Network access may be required depending on the sync target.
metadata:
  system: "ai-plc"
  kind: "skill"
  status: "deprecated"
---

# AI-PLC External Sync

> ⚠️ **Deprecated**
>
> このスキルは標準インストール対象外です。
>
> 理由:
> - `.claude/db/sync.py` 実装がこのリポジトリに同梱されていない
> - 利用側プロジェクト固有の同期アダプタ要件が大きい
>
> 必要な場合のみ、利用側プロジェクトで同期エンジンを実装した上で再導入してください。

`.claude/db/ai_plc.db` や `backlog.yaml` をローカルの正本として扱い、必要な場合のみ外部システムと同期する。

## When to Use

- 「DBを同期して」「外部タスクを取り込んで」→ pull
- 「タスクを外部システムに反映して」「Push」→ push
- 「DB同期状態を確認して」「syncステータス」→ status
- 「DB同期」→ sync (双方向)
- プロジェクトやタスクをローカルで追加・更新した後に外部システムへ反映したいとき
- 外部システム側の最新データをローカルに取り込みたいとき

## Commands

```bash
python3 .claude/db/sync.py pull              # 外部 → ローカル
python3 .claude/db/sync.py push              # ローカル → 外部
python3 .claude/db/sync.py sync              # 双方向 (pull → push)
python3 .claude/db/sync.py status            # 差分プレビュー
python3 .claude/db/sync.py pull --dry-run    # dry-run (変更なし)
python3 .claude/db/sync.py push --dry-run    # dry-run (変更なし)
```

## Prerequisites

- `.claude/db/ai_plc.db` が存在すること（なければ `python3 .claude/db/init_db.py --import` で作成）
- `intent.yaml` に `sync_targets` が定義されていること、またはプロジェクト固有の同期アダプタが存在すること
- 注意: このリポジトリには `.claude/db/sync.py` 本体は同梱されていないため、必要なら利用側プロジェクトで提供する

## Sync Logic

- **Pull**: 外部システム側を query → 外部更新時刻で差分検出 → `.claude/db/ai_plc.db` を更新
- **Push**: `updated_at > last_sync_at` の行を検出 → 外部システムに PATCH/POST または同等操作
- **Conflict**: Pull時にローカルも変更されている行は CONFLICT としてスキップ（安全側）

## Data Model

| テーブル | ローカルDB | 同期先 | 用途 |
| --- | --- | --- | --- |
| projects | `.claude/db/ai_plc.db` | 任意の外部台帳 | プロジェクト管理 |
| tasks | `.claude/db/ai_plc.db` | 任意の外部台帳 | タスク管理 |

## Typical Workflow

1. `status` で差分を確認
2. `pull` で外部システム側の最新を取得
3. ローカルで `plc_query.py` を使って編集
4. `push` で外部システムに反映

## Related Files

- `.claude/db/ai_plc.db` — SQLite DB本体
- `.claude/db/init_db.py` — スキーマ作成 + マイグレーション
- `.claude/db/plc_query.py` — ローカルクエリヘルパー
- `.claude/db/sync.py` — 同期エンジン（利用側プロジェクトで提供する想定）
- `.claude/db/README.md` — ドキュメント
