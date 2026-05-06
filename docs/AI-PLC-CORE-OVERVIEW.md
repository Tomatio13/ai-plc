# AI-PLC Core Overview

## 目的

このドキュメントは、`core/rules` と `core/skills/ai-plc` の役割を短時間で把握するための概要です。
AI-PLC は、AI エージェントが「調査だけで終わらず、実際の成果物を作る」ことを前提にした、4ステージの実行パイプラインです。

## 全体像

AI-PLC の中心は次の 3 層です。

1. `core/rules/`
   - 全スキルに共通で効く実行ルールです。
   - コンテキスト継承、セッション分割、次アクション提案、検証、成果物反映の基準を定義します。
2. `core/skills/ai-plc/`
   - Stage 1 から Stage 4 までの実行スキル本体です。
   - Goal の受け取りから、分解、実行準備、実作業、成果物反映までを担当します。
3. `core/skills/ai-plc/templates/`
   - Role テンプレートと Agent テンプレートです。
   - Stage 1 の視点選択と Stage 3 の Agent 定義生成で参照されます。

## パイプラインの考え方

AI-PLC は次の流れで進みます。

1. Collection
   - Goal を受け取り、実行スコープと Context を初期化します。
2. Inception
   - Goal を SubLayer と Task に分解し、`backlog.yaml` を作ります。
3. Construction
   - 各タスクを実行するための Agent 定義を生成します。
4. Operation
   - Agent 定義に従ってタスクを実行し、成果物を作り、関連ファイルへ反映します。

この流れは固定ではなく、`simple` / `standard` / `complex` の深度判定で調整されます。

## Rules の要約

### `ai-plc-system.md`

ルートルールです。全スキルの前提になります。

- AI-PLC の目的を「実際に動く成果物の作成」と定義します。
- Context Cascade を定義します。
  - `global_immutable`: 子へ不変継承
  - `overridable`: 子で上書き可能
  - `local_only`: 子へ非伝播
- Scope 配下の標準成果物構造を定義します。
  - `intent.yaml`
  - `context.yaml`
  - `backlog.yaml`
  - `Context/`
  - `Skills/` / `Rules/` / `Subagents/` / `Documents/`
- Mob Checkpoint を共通ルール化します。
  - 人間の確認なしで先へ進まない前提です。
- 永続記憶の扱いを定義します。
  - `{{agent_home}}/memory.md`
  - `{{agent_home}}/user.md`
  - `{{agent_home}}/soul.md`
- Post-Deliver Propagation を必須化します。
  - `backlog.yaml`
  - `context.yaml`
  - `memory.md`
  - `user.md`
  - `sync_targets`
  - wiki
  - log

要するに、AI-PLC の共通 OS に相当するルールです。

### `ai-plc-session.md`

セッション運用ルールです。長い作業を壊さず継続するための基準を定義します。

- セッション分割の閾値を定義します。
  - SubLayer 数
  - タスク数
  - 見積時間
  - 階層深さ
- 新スレッドに引き継ぐべき必須コンテキストを定義します。
- 子スレッド完了時の親への報告フォーマットを定義します。
- セッション終了前の確認項目を定義します。
- 完了報告の出力フォーマットを定義します。
  - 現在位置
  - 完了サマリ
  - 進捗ダッシュボード
  - Next Action Protocol

特に重要なのは、作業完了時に「次に何をするべきか」を必ず具体化する点です。

### `ai-plc-adaptive.md`

ワークフローの深度調整と次アクション判定のルールです。

- Goal の複雑度から `simple` / `standard` / `complex` を判定します。
- Goal の性質から Role を選びます。
  - product manager
  - system architect
  - tech lead
  - developer
  - content strategist
  - generic
- Goal の実行様式を判定します。
  - `direct`
  - `platform_builder`
- Stage 完了後の Next Action を自動提案します。
- 実行中の問題を検知し、Stage 1 や Stage 2 へ戻る Backtrack ルールを定義します。
- `standard` 以上では Stage 3 を省略できないことを明示します。

このルールは、AI-PLC を固定手順ではなく適応型パイプラインとして動かす中核です。

## Skills の要約

### `README.md`

システムの入口です。

- AI-PLC の目的
- 4ステージ構成
- Rules / Templates / Memory / Wiki の関係
- 命名規則
- コア原理

最初に全体像を掴むファイルとして機能します。

### `01-collection/SKILL.md`

Stage 1 です。パイプラインの初期化を担当します。

- Goal と Mode を受け取ります。
- 新規 Scope / Sub-Agent Scope / 再初期化を判定します。
- Adaptive Workflow 深度を判定します。
- ディレクトリ構造を生成します。
- `intent.yaml` を作ります。
- Context を収集して `Context/` と `context.yaml` を作ります。
- 必要なら Project Registry や wiki へ波及します。

役割は「何を作るか」と「それを進めるための初期コンテキスト」を確立することです。

### `02-inception/SKILL.md`

Stage 2 です。Goal の分解を担当します。

- Context を読み、追加調査を行います。
- 分解戦略を選択します。
- Goal を Task と SubLayer に分解します。
- `backlog.yaml` を生成します。
- SubLayer が必要なら `sublayers/` を初期化します。
- 外部委譲すべきタスクがあれば External Sync を促します。

役割は「Goal を実行可能な単位へ落とす」ことです。

### `03-construction/SKILL.md`

Stage 3 です。実行用 Agent 定義の生成を担当します。

- `backlog.yaml` を読み込みます。
- タスクタイプから Lite / Full の tier を判定します。
- `templates/agents/` などから参照テンプレートを選びます。
- 各タスクの Agent 定義を `Agents/` に生成します。
- 単体生成と一括生成の両方に対応します。
- スコープ外タスクを見つけた場合は External Sync を促します。

役割は「Task を AI が安全に実行できる手順書へ変換する」ことです。

### `04-operation/SKILL.md`

Stage 4 です。実際のタスク実行を担当します。

- 依存関係を解決し、実行可能タスクを特定します。
- タスク実行前に追加 Context を収集します。
- Agent 定義に従って作業を進めます。
- 成果物を `Documents/` などへ保存します。
- Phase 5.5 で 3 層検証を必須実行します。
- Phase 7 で Propagation を必須実行します。
- 必要に応じて Backtrack を提案します。
- `platform_builder` モードでは Production Skill 生成と量産ループまで扱います。

役割は「計画を成果物に変え、その結果を周辺状態へ反映する」ことです。

### `db-sync/SKILL.md`

外部同期スキルですが、現状は deprecated です。

- 標準インストール対象外です。
- 同期エンジン実装がこのリポジトリに含まれていません。
- 利用側プロジェクトで個別実装する前提です。

つまり、AI-PLC の標準フローはローカルファイル正本で成立し、外部同期は任意拡張です。

## Rules と Skills の関係

実行の依存関係は概ね次の構造です。

1. `ai-plc-system.md`
   - 全体の土台
2. `ai-plc-session.md`
   - 進め方と報告形式
3. `ai-plc-adaptive.md`
   - 深度判定と次アクション
4. `01-collection` 〜 `04-operation`
   - 実際のパイプライン処理

各 Stage スキルは、単独のコマンドではなく、3つの rule に支えられた実行ステージとして設計されています。

## 重要な設計上の特徴

### 1. Local-first

- ローカルファイルが正本です。
- 特定 SaaS への依存を避けています。
- 外部同期は `sync_targets` がある場合だけ発動します。

### 2. Context を資産として扱う

- `Context/` が実体です。
- `context.yaml` が索引です。
- 親子スコープ間で Context Cascade を使って継承します。

### 3. 実行より前に構造を作る

- Stage 1 で実行スコープを作ります。
- Stage 2 で Task を定義します。
- Stage 3 で Agent を生成します。
- Stage 4 で初めて実作業に入ります。

この順序により、行き当たりばったりな実行を避けます。

### 4. 完了の定義が厳密

- 成果物を作るだけでは不十分です。
- 検証が必要です。
- `backlog.yaml` と `context.yaml` の更新が必要です。
- 必要に応じて `memory.md`、`user.md`、wiki、外部同期まで確認します。

## 読む順番の推奨

初見なら次の順で読むと理解しやすいです。

1. `core/skills/ai-plc/README.md`
2. `core/rules/ai-plc-system.md`
3. `core/rules/ai-plc-adaptive.md`
4. `core/rules/ai-plc-session.md`
5. `core/skills/ai-plc/01-collection/SKILL.md`
6. `core/skills/ai-plc/02-inception/SKILL.md`
7. `core/skills/ai-plc/03-construction/SKILL.md`
8. `core/skills/ai-plc/04-operation/SKILL.md`

## ひとことでまとめると

AI-PLC の core は、AI に単発作業をさせる仕組みではなく、Goal を受け取って Context を集め、Task に分解し、実行用 Agent を作り、成果物と知見を確実に残すための実行基盤です。
