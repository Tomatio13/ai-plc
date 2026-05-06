# 変更履歴

このファイルでは、このプロジェクトの主な変更を記録します。

## [未リリース]
## [2026-05-06]

### 追加
- Codex のインストールとセットアップに対応する `install-codex.sh` を追加しました。
- インストーラーとドキュメントの導線全体で knowledge path 対応を追加しました。
- Scope テンプレートを追加しました。
  - `core/skills/ai-plc/templates/TPL_backlog.yaml`
  - `core/skills/ai-plc/templates/TPL_context.yaml`
  - `core/skills/ai-plc/templates/TPL_intent.yaml`
  - `core/skills/ai-plc/templates/TPL_variables.yaml`
- ドキュメントを追加しました。
  - `docs/AI-PLC-CORE-OVERVIEW.md`
  - `docs/AI-PLC-HUMAN-GUIDE.md`
  - `docs/AI-PLC-REFACTORING-POLICY.md`
  - `docs/MIGRATION-NOTION-REMOVAL.md`
- `.gitignore` を追加しました。

### 変更
- ルール、スキル、エージェントテンプレート、ロールテンプレート全体で AI-PLC のコアガイダンスを簡素化しました。
- `README.md`、テンプレート、移行ドキュメントに agent home abstraction の説明を追加しました。
- Codex 対応と knowledge path の扱いに合わせて、インストーラーとアンインストーラーのスクリプトを更新しました。
- collection と inception のスキルが新しい Scope テンプレートを参照するよう更新しました。

### 削除
- コアワークフローとセットアップガイドから、必須だった Notion 依存を削除しました。

### 注記
- このリリース範囲は `0550649` から `abb525f` までのコミットを対象としています。
- `masato` による変更は PR `#1` から `#5` を通じて `main` にマージされました。
