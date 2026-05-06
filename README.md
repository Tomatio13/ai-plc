# AI-PLC — AI Product Lifecycle Pipeline

PMBOKの知識体系をAIエージェント向けに再設計した**4ステージパイプライン**。  
Claude Code / Cursor / Codex の各環境にインストールでき、既存の設定を壊しません。

## 方針

- **Local-first** — `intent.yaml` / `backlog.yaml` / `context.yaml` / `Documents/` を正本として運用
- **Notion非依存** — Notion は必須ではなく、外部同期が必要な場合のみ任意で連携
- **External Syncは任意** — `sync_targets` 未設定時は同期せず、ローカル運用だけで完結

## 論理パス

- `{{agent_home}}` は利用中ツールのローカル作業ディレクトリを表す
- 対応:
  - Claude Code → `.claude`
  - Cursor → `.cursor`
  - Codex → `.codex`
- rules / skills / docs の本文では、ツール別パスの列挙ではなく `{{agent_home}}` を使う

## 新ツール追加時の対応

- ルール:
  - `{{agent_home}}` の対応表が書かれているファイルには、新ツール追加時に追記が必要
  - `{{agent_home}}` を本文で使っているだけのファイルは、原則そのままでよい
  - 実パスを環境別に説明しているファイルは、新ツール追加時に追記が必要

| ファイル | `{{agent_home}}` の役割 | 追記要否 | 追記内容 |
|----------|-------------------------|----------|----------|
| `README.md` | 対応表の定義元 | 必須 | 対応表と導入手順 |
| `core/rules/ai-plc-system.md` | 対応表の定義元 | 必須 | 対応表 |
| `claude/AGENTS.md.template` | 対応表の定義元 | 必須 | 対応表 |
| `docs/MIGRATION-NOTION-REMOVAL.md` | 対応表の定義元 | 必須 | 対応表 |
| `templates/memory.md` | 本文で利用 | 不要 | 原則なし |
| `core/skills/ai-plc/README.md` | 本文で利用 | 不要 | 原則なし |
| `core/skills/ai-plc/01-collection…` | 本文で利用 | 不要 | 原則なし |
| `core/skills/ai-plc/04-operation…` | 本文で利用 | 不要 | 原則なし |

| ファイル | 実パスの役割 | 追記要否 | 追記内容 |
|----------|--------------|----------|----------|
| `install.sh` | installer 振り分け | 必須 | 選択肢と呼び出し |
| `install-<tool>.sh` | 新ツール installer 本体 | 必須 | 新規作成 |
| `uninstall.sh` | 削除対象の列挙 | 必須 | 削除対象と除外案内 |
| `README.md` | 実パスの利用者向け説明 | 必須 | Quick Start と配置一覧 |
| `<tool>/...` | ツール固有資産 | 条件付 | ルールやテンプレート追加 |
| `claude/CLAUDE.md.template` | Claude専用説明 | 通常不要 | 共通化時のみ調整 |
| `cursor/rules/*.mdc` | Cursor専用ルール形式 | 条件付 | 同種ツールなら追加 |

- 追加後の確認:
  - `bash -n install.sh install-cc.sh install-cursor.sh install-codex.sh install-<tool>.sh uninstall.sh`
  - `./install-<tool>.sh --dry-run --target /tmp/ai-plc-<tool>-test`
  - `./install.sh --dry-run --target /tmp/ai-plc-universal-test <tool>`

## パイプライン概要

```
Collection → Inception → Construction → Operation
(Goal設定)    (タスク分解)  (スキル生成)    (実行・成果物)
```

| Stage | 名称 | 概要 |
|-------|------|------|
| 1 | **Collection** | Goal設定・Context収集・Execution Context確立 |
| 2 | **Inception** | Goal分析・再帰的分解・Backlog生成 |
| 3 | **Construction** | 実行スキル生成・Agent定義 |
| 4 | **Operation** | タスク実行・成果物生成・知見伝播 |

## クイックスタート

### Claude Code

```bash
git clone https://github.com/YOUR_USER/ai-plc.git
cd ai-plc
./install-cc.sh --target /path/to/your/project
```

### Cursor

```bash
git clone https://github.com/YOUR_USER/ai-plc.git
cd ai-plc
./install-cursor.sh --target /path/to/your/project
```

### Codex

```bash
git clone https://github.com/YOUR_USER/ai-plc.git
cd ai-plc
./install-codex.sh --target /path/to/your/project
```

### まとめてインストール

```bash
./install.sh --target /path/to/your/project all
```

### dry-run（確認のみ）

```bash
./install-cc.sh --dry-run --target /path/to/your/project
```

## インストール内容

### Claude Code

| 配置先 | 内容 |
|--------|------|
| `.claude/skills/ai-plc/` | 4ステージスキル + テンプレート群 |
| `.claude/rules/ai-plc-*.md` | システム・セッション・Adaptiveルール |
| `.claude/commands/` | スラッシュコマンド（sense, focus, deliver, status, daily） |
| `.claude/agents/` | エージェント定義（researcher, reviewer, analyst, syncer） |
| `CLAUDE.md` | AI-PLCセクションをマージ（既存保持） |
| `AGENTS.md` | AI-PLCセクションをマージ（既存保持） |
| `.claude/soul.md` | AI行動原則テンプレート（新規のみ） |
| `.claude/user.md` | ユーザーモデルテンプレート（新規のみ） |
| `.claude/memory.md` | メモリポインタ（新規のみ） |
| `.claude/wiki/` | Knowledge Wiki初期構造（新規のみ） |

### Cursor

| 配置先 | 内容 |
|--------|------|
| `.cursor/skills/ai-plc/` | 4ステージスキル + テンプレート群 |
| `.cursor/rules/ai-plc-*.mdc` | MDCフォーマットのルール（alwaysApply） |
| `.cursor/soul.md` | AI行動原則テンプレート（新規のみ） |
| `.cursor/user.md` | ユーザーモデルテンプレート（新規のみ） |
| `.cursor/memory.md` | メモリポインタ（新規のみ） |
| `.cursor/wiki/` | Knowledge Wiki初期構造（新規のみ） |

### Codex

| 配置先 | 内容 |
|--------|------|
| `.codex/skills/ai-plc/` | 4ステージスキル + テンプレート群 |
| `AGENTS.md` | AI-PLCセクションをマージ（既存保持） |
| `.codex/soul.md` | AI行動原則テンプレート（新規のみ） |
| `.codex/user.md` | ユーザーモデルテンプレート（新規のみ） |
| `.codex/memory.md` | メモリポインタ（新規のみ） |
| `.codex/wiki/` | Knowledge Wiki初期構造（新規のみ） |

## 安全性

- **既存ファイルは上書きしません** — バックアップ（`.bak.YYYYMMDD`）を作成してから更新
- **CLAUDE.md / AGENTS.md はマージ** — `<!-- AI-PLC START/END -->` マーカーで管理
- **テンプレートファイルはスキップ** — `soul.md`, `user.md` 等は既存がなければのみ配置
- **dry-runモード** — `--dry-run` で事前確認可能
- **アンインストール可能** — `./uninstall.sh` で配置ファイルを除去

## ディレクトリ構造

```
ai-plc/
├── install.sh               # ユニバーサルインストーラ
├── install-cc.sh             # Claude Code用
├── install-cursor.sh         # Cursor用
├── install-codex.sh          # Codex用
├── uninstall.sh              # アンインストーラ
├── .ai-plc-version           # バージョン情報
├── LICENSE                   # MIT License
│
├── core/                     # コアファイル（環境共通）
│   ├── skills/ai-plc/        # 4ステージスキル + テンプレート
│   └── rules/                # 3つのルールファイル
│
├── claude/                   # Claude Code固有
│   ├── CLAUDE.md.template
│   ├── AGENTS.md.template
│   ├── commands/             # スラッシュコマンド
│   └── agents/               # エージェント定義
│
├── cursor/                   # Cursor固有
│   └── rules/                # .mdcフォーマットルール
│
├── codex/                    # CodexはAGENTS.mdと.codex/を使用
│   └── (shared via template)
│
├── templates/                # ジェネリックテンプレート
│   ├── soul.md, user.md, memory.md
│   └── wiki/
│
└── docs/                     # ドキュメント
    └── ARCHITECTURE.md
```

## コア原理

| 原理 | 説明 |
|------|------|
| **Context Cascade** | 親→子スコープへの3分類コンテキスト伝播（immutable / overridable / local） |
| **Fractal Decomposition** | Goalの再帰的分解とSub-Agent Scope生成 |
| **Adaptive Workflow** | Simple / Standard / Complex の3段階深度自動判定 |
| **Self-Describing Task** | コンテキスト付きタスク委譲構造 |

## 運用原則

- `backlog.yaml` と `Documents/` を中心に進捗と成果物を管理
- 永続メモリは `{{agent_home}}/wiki/` の Markdown を使用
- `sync_targets` は Linear / GitHub Issues / SQLite / CSV などを明示設定したときのみ利用
- `db-sync` スキルは deprecated で、標準インストール対象外

## カスタマイズ

インストール後、以下のファイルをプロジェクトに合わせて編集してください:

1. **`.claude/soul.md`** — AIの行動原則・アイデンティティ
2. **`.claude/user.md`** — あなたのプロフィール・好み
3. **`CLAUDE.md`** — プロジェクト固有の設定を追記

Codex を使う場合:

1. **`.codex/soul.md`** — AIの行動原則・アイデンティティ
2. **`.codex/user.md`** — あなたのプロフィール・好み
3. **`AGENTS.md`** — プロジェクト固有の設定を追記

Cursor を使う場合:

1. **`.cursor/soul.md`** — AIの行動原則・アイデンティティ
2. **`.cursor/user.md`** — あなたのプロフィール・好み
3. **`.cursor/wiki/`** — 永続知識の蓄積先

## アンインストール

```bash
./uninstall.sh --target /path/to/your/project
```

`.claude/*` / `.cursor/*` / `.codex/*` 配下の `soul.md`, `user.md`, `memory.md`, `wiki/` はカスタマイズ済みの可能性があるため削除されません。

## License

MIT License — See [LICENSE](LICENSE) for details.
