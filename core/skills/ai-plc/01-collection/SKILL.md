---
name: 01-collection
description: Initialize an AI-PLC scope from a goal, collect context, and create intent.yaml and context.yaml. Use when starting a new scope, creating a sub-scope, or re-initializing an existing scope before planning or execution.
compatibility: Works in local agent environments that can read and write workspace files. Web access is optional for external context collection.
metadata:
  stage: "1"
  system: "ai-plc"
  kind: "skill"
---

# SKL_plc_01_collection

Stage 1. Goal を受け取り、実行 Scope と Context を初期化する。

## Required Context

- `core/skills/ai-plc/README.md`
- `core/rules/ai-plc-system.md`
- `core/rules/ai-plc-session.md`
- `core/rules/ai-plc-adaptive.md`
- `core/skills/ai-plc/templates/`

## Inputs

- `goal`
- `mode` optional
- `owner` optional
- `deadline` optional
- `parent_scope` optional
- `scope_name` optional

## Outputs

- `intent.yaml`
- `context.yaml`
- `Context/`
- `variables.yaml` optional
- Scope directory structure

## Runtime Flow

1. Scope type を判定する
   - 新規 Scope
   - Sub-Agent Scope
   - 既存 Scope の再初期化
2. Goal を分析し、`workflow_depth` と `mode` を決める
3. Scope の標準ディレクトリ構造を作る
4. `intent.yaml` を作成または更新する
5. Context を収集する
   - workspace search を優先
   - 必要時だけ外部情報を使う
6. `Context/` に実体を保存する
7. `context.yaml` を生成または更新する
8. `platform_builder` の場合だけ `variables.yaml` を作る
9. Mob Checkpoint で完了確認と次 Stage 提案を出す

## Required Behavior

- `workflow_depth` は `simple` / `standard` / `complex` のいずれかに正規化する
- Sub-Layer 作成時は Context Cascade を守る
- `sync_targets` の既定値は空配列とする
- 新規 Scope 作成時だけ Project Registry 登録を検討する
- 再初期化では既存成果物を不用意に上書きしない

## Mob Checkpoint

Phase 末尾で次を必ず出す。

1. 現在位置
2. 完了サマリ
3. 進捗ダッシュボード
4. Next Action Protocol

## Must Not

- Goal だけ受けて Context を空のまま先へ進めない
- `workflow_depth` を自由記述にしない
- Mob Checkpoint を省略しない
