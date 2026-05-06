# AI-PLC Human Guide

## 目的

このドキュメントは、AI-PLC を人間が理解し、保守し、拡張するための完全版ガイドです。
`core/` 配下は AI 実行時の runtime 文書として最小化しているため、背景、設計意図、運用指針はこのファイルにまとめます。

## まず何を理解すべきか

AI-PLC は、AI に単発の作業をさせる仕組みではありません。
Goal を受け取り、Context を集め、Task に分解し、実行用 Agent を作り、成果物と知見を残すためのライフサイクルです。

中核は次の 4 Stage です。

1. Collection
   - Goal と Scope を初期化する
2. Inception
   - Goal を Task と Sub-Layer に分解する
3. Construction
   - Task 実行用 Agent を生成する
4. Operation
   - 実行、検証、反映を行う

## ディレクトリ構造

AI-PLC の理解は、まず `core/` と `docs/` の分離から始まります。

### `core/`

AI が実行時に読む最小文書群です。

- `core/rules/`
  - 共通 runtime ルール
- `core/skills/ai-plc/`
  - 4 Stage のスキル
- `core/skills/ai-plc/templates/`
  - role template
  - agent template

### `docs/`

人間が読む説明、設計思想、方針文書です。

- `AI-PLC-CORE-OVERVIEW.md`
  - 短い概要
- `AI-PLC-REFACTORING-POLICY.md`
  - core の保守方針
- `AI-PLC-HUMAN-GUIDE.md`
  - 本ファイル

## 3 種類の文書の役割

### 1. Rule

`core/rules/*.md`

役割:

- 全 skill に共通で効く制約を書く
- runtime の優先順位、禁止事項、検証条件を書く

書くべき内容:

- 必須行動
- 禁止事項
- 最低限の判定基準

書かない方がよい内容:

- 長い背景説明
- 歴史
- 旧体系比較
- 実装例の羅列

### 2. Skill

`core/skills/ai-plc/*/SKILL.md`

役割:

- 各 Stage で何を入力に受け、何を出力し、どう進めるかを定義する

書くべき内容:

- Required Context
- Inputs
- Outputs
- Runtime Flow
- Required Behavior
- Must Not

### 3. Template

`core/skills/ai-plc/templates/`

役割:

- role template
  - どの視点で分解・判断するか
- agent template
  - どの型で実行フローを作るか

## Rule の設計意図

### `core/rules/ai-plc-system.md`

AI-PLC 全体の共通 OS です。

主な責務:

- Goal を成果物へ結びつける
- Context Cascade を定義する
- Scope ファイル構造を固定する
- Propagation と Verification の最低条件を持つ

重要なのは、ここが「思想書」ではなく「runtime 制約」である点です。

### `core/rules/ai-plc-session.md`

セッションの進め方を固定するルールです。

主な責務:

- セッション分割
- handoff
- 完了報告
- Next Action
- Mob Checkpoint 出力

この rule があることで、作業完了時に「次に何をするか」が必ず見える状態を維持できます。

### `core/rules/ai-plc-adaptive.md`

適応型の分岐を定義するルールです。

主な責務:

- `workflow_depth`
  - `simple`
  - `standard`
  - `complex`
- `mode`
  - `direct`
  - `platform_builder`
- focus role
- next action
- backtrack

AI-PLC を固定の 4 Stage 手順ではなく、Goal に応じた可変パイプラインとして扱うための中心です。

## もともとの背景と考え方

このセクションは、以前 `rules` や `skills` に直接書かれていた背景説明を、人向け文書として再配置したものです。

### 1. なぜ「成果物があること」を完了条件にしたのか

AI を使った作業は、説明、提案、設計書、分析メモで終わりやすい問題があります。
しかし、実務では「よく考えられていること」より「実際に使える状態になっていること」が重要です。

そのため AI-PLC では、特に実装系 task に対して次の姿勢を取っています。

- 設計だけで終わらせない
- 実際のファイル、コード、設定、成果物を残す
- 完了時に更新対象まで反映する

これは「AI を相談相手ではなく実行主体として扱う」ための前提です。

### 2. なぜ 4 Stage 構造なのか

4 Stage は、単に工程を並べたものではありません。
AI が大きな Goal を扱うときに起こりやすい失敗を分離するための構造です。

- Collection
  - 何をやるか曖昧なまま走る失敗を防ぐ
- Inception
  - 大きすぎる Goal をそのまま実行して破綻する失敗を防ぐ
- Construction
  - Task があるだけで実行手順がない状態を防ぐ
- Operation
  - 作ったが反映していない、検証していない、次につながらない状態を防ぐ

言い換えると、4 Stage は「理解不足」「分解不足」「実行設計不足」「反映不足」をそれぞれ潰すための骨格です。

### 3. なぜ Context を強く扱うのか

AI は会話だけに依存すると、途中で文脈を落とします。
また、親 Scope で集めた情報を子 Scope がうまく再利用できないと、再帰的な分解で品質が急落します。

そこで AI-PLC では、Context を会話の副産物ではなく資産として扱います。

- `Context/`
  - 実体
- `context.yaml`
  - 索引
- Context Cascade
  - 伝播ルール

この構造の狙いは、文脈を「覚えているかどうか」に依存させないことです。

### 4. なぜ Mob Checkpoint を強制するのか

AI は速く進められますが、速く間違えることもできます。
特に分解、設計、外部反映、公開判断は、人間の意図を外したまま進むとコストが大きいです。

そのため AI-PLC は、止まるべき箇所で止まる設計です。

Mob Checkpoint の狙い:

- 分解の誤りを早く止める
- 方向修正の余地を残す
- ユーザーの control を維持する
- 「承認したら何が起きるか」を可視化する

これは単なる慎重さではなく、AI の速度と人間の判断を接続するためのインターフェースです。

### 5. なぜ Adaptive なのか

すべての task に同じ重いフローを適用すると、AI-PLC は過剰に遅くなります。
逆に、常に最短経路を取ると、大きい task で破綻します。

この矛盾を避けるために、Adaptive Workflow を入れています。

- `simple`
  - 速さを優先
- `standard`
  - 分解と整合性を優先
- `complex`
  - 再帰と検証を優先

重要なのは、Adaptive は「手抜き」ではないことです。
task に応じて、どこに厳密さをかけるかを変える仕組みです。

### 6. なぜ Backtrack を正式な仕組みにしたのか

多くのワークフローは前進しか想定していません。
しかし実際の作業では、検証の結果、前提や分解が間違っていたと分かることが頻繁にあります。

AI-PLC はこれを異常系ではなく通常系として扱います。

Backtrack の意味:

- 失敗ではなく、前提更新のための移動
- 後戻りを明示的な操作にする
- backlog に理由を残して学習可能にする

つまり、Backtrack は「進行の破綻」ではなく「適応の一部」です。

### 7. なぜ Verification と Propagation を分けたのか

成果物ができた直後は、「できた」という感覚が強く、検証や反映が後回しになりがちです。
AI-PLC ではそこを 2 段に分けています。

- Verification
  - 本当に妥当か
- Propagation
  - その結果を周辺状態へ反映したか

この分離により、次の典型的な事故を避けます。

- 作ったが壊れている
- 作ったが backlog が未更新
- 作ったが Context に学びが残らない
- 作ったが次の作業者に引き継げない

### 8. なぜ role template と agent template を分けるのか

以前の長い文書では、視点と実行手順が混ざりやすい状態でした。
しかしこの 2 つは別物です。

- role template
  - 何を見るか
  - 何を重視するか
- agent template
  - どう進めるか
  - どの順で止まるか

たとえば product_manager と system_architect は、同じ Goal を見ても分解軸が違います。
一方で、research や review の agent flow は role をまたいで再利用できます。

この分離により、視点の変更と実行型の変更を独立に扱えます。

### 9. なぜ local-first なのか

特定の SaaS を正本にすると、AI の実行環境や project ごとの差分に引きずられます。
また、同期失敗や権限不足でフロー全体が止まりやすくなります。

AI-PLC は次の理由で local-first を採っています。

- 最低限のファイルだけで成立する
- バージョン管理しやすい
- 外部同期を opt-in にできる
- エージェント環境差分を減らせる

External Sync を optional にしているのも同じ理由です。

### 10. なぜ説明を core から docs に移したのか

もともとの `rules` と `skills` は、人向けの解説と AI 向け runtime 指示が混在していました。
その状態には次の問題がありました。

- AI が読むには長すぎる
- 本当に効く制約の密度が薄くなる
- 同じ説明が各 skill に重複する
- 修正時に整合性が崩れやすい

そのため現在は、役割を次のように分けています。

- `core`
  - AI がその場で判断を誤ると困る実行ルール
- `docs`
  - 設計背景、意図、思想、比較、導入説明

これは単なる整理ではなく、AI に効く文書と人に効く文書の最適化です。

## Skill の設計意図

### `01-collection`

目的:

- Goal を Scope に変換する
- Context を集める
- `intent.yaml` と `context.yaml` を作る

この Stage が弱いと、以降の分解と実行は全部ぶれます。

### `02-inception`

目的:

- Goal を Task と Sub-Layer に落とす
- `backlog.yaml` を作る

この Stage が弱いと、実行可能な単位が作れず、Operation が肥大化します。

### `03-construction`

目的:

- backlog 上の task を Agent 定義へ変換する

この Stage の価値は、Task を「AI が安全に動ける手順書」に変える点にあります。

### `04-operation`

目的:

- 実行する
- 検証する
- 反映する

単に成果物を出すだけでなく、`backlog.yaml`、`context.yaml`、知見ストアまで反映して完了させるのが特徴です。

## Template の設計意図

### role template

role template は「何を見るか」を定義します。

例:

- `TPL_role_product_manager`
  - 価値、課題、MVP
- `TPL_role_system_architect`
  - 境界、依存、NFR
- `TPL_role_developer`
  - 実装、変更最小化、テスト
- `TPL_role_tech_lead`
  - 分解、依存、順序管理

### agent template

agent template は「どう進めるか」を定義します。

例:

- `TPL_research_agent`
  - 調査と分析
- `TPL_implementation_agent`
  - 動くシステム構築
- `TPL_coding_agent`
  - 実装計画からコード変更へ
- `TPL_review_agent`
  - 検証と改善指示

### role template に以前書かれていた考え方

role template は元々、かなり多くの背景説明を含んでいました。
その中心にあった考え方は次の通りです。

- product_manager
  - Discovery と Delivery を分ける
  - MVP 先行
  - 価値仮説で分解する
- system_architect
  - 境界を明示する
  - NFR を早めに表へ出す
  - 技術的負債を設計段階で抑える
- content_strategist
  - 読者と配信導線を中心に構成する
  - 品質管理を制作フローに埋め込む
- developer
  - 既存コードを尊重する
  - 最小変更で進める
  - テストを completion criteria に含める
- tech_lead
  - 「どう作るか」ではなく「どう分けて進めるか」を担う
  - 実行順序と依存関係を可視化する
- generic
  - domain 未確定時の受け皿として使う
  - ただし必要なら専門 role へ切り替える

### agent template に以前書かれていた考え方

agent template は元々、旧テンプレートとの対応や詳細な phase 例を多く持っていました。
背景にあった考え方は次の通りです。

- research agent
  - まず調査範囲を固定する
  - 収集と分析を分ける
  - 出典を結果の一部として扱う
- implementation agent
  - 設計だけでなく「動くもの」までを責務にする
  - 実体作成、設定、初期投入、利用ガイドまで一続きで扱う
- coding agent
  - 計画と実装を分ける
  - 承認前に大きな変更へ進まない
  - Brownfield では in-place を原則にする
- review agent
  - 指摘だけで終わらない
  - 改善指示として返す
  - verification を明示的な成果物にする
- operation agent
  - 繰り返し実行を loop として扱う
  - 評価データを結果に含める

## 以前 rules に含まれていた周辺思想

### Knowledge Lint

以前の `ai-plc-system.md` には、wiki 側の知識ベースを定期点検する思想が強く入っていました。
これは「成果物だけ増えて知識体系が壊れる」ことを避けるためのものです。

狙い:

- 矛盾の可視化
- 孤立ページの発見
- 出典不足の是正
- 相互参照の補強

### Contradiction を残す理由

知識が更新されたとき、古い記述を静かに消すと、なぜ変わったのか追えません。
そのため AI-PLC では、矛盾は一旦 `CONTRADICTION` として残す思想がありました。

これは次の価値を持ちます。

- 学習履歴が残る
- 誰の判断で変わったか追える
- 「いま確定していない論点」を可視化できる

### Query Return

Operation 中の調査結果は、その task だけに閉じず wiki に戻す、という考え方もありました。
これは「せっかく調べたのに、次回また同じことを調べる」無駄を減らすためです。

つまり、AI-PLC は task 完了だけでなく、knowledge compounding も狙っています。

### External Sync の位置づけ

External Sync は主役ではありません。
もともとの説明でも、次の位置づけでした。

- 正本はローカル
- 外部同期は必要時のみ
- 役割は delegation と status sync

これは、外部システム中心設計にすると AI-PLC の portability が下がるためです。

## Context Cascade とは何か

親 Scope から子 Scope へ、同じ情報を無制限にコピーすると、文脈が濁ります。
そのため AI-PLC では伝播を 3 種類に分けます。

1. `global_immutable`
   - 必ず継承
   - 子で変更しない
2. `overridable`
   - 継承する
   - 必要なら子で上書き
3. `local_only`
   - 子へ持ち込まない

これは再帰的な Sub-Layer 運用で特に重要です。

## Verification と Propagation

AI-PLC で完了判定が厳しいのは意図的です。

### Verification

成果物ができたら、`workflow_depth` に応じて検証します。

- `simple`
  - L1
- `standard`
  - L1 + L2
- `complex`
  - L1 + L2 + L3

### Propagation

検証後、次を確認します。

- `backlog.yaml`
- `context.yaml`
- `memory.md`
- `user.md`
- External Sync
- wiki
- `log.md`
- Project Registry

この 2 段階により、「作っただけで終わる」状態を防ぎます。

## Human-in-the-loop

AI-PLC は full auto を目指していません。
止まるべき場所で止まり、人間が判断する設計です。

Mob Checkpoint の目的:

- 誤分解を防ぐ
- 実行前に方向修正できるようにする
- ユーザーのコントロール感を維持する

## どこに何を書けばいいか

### `core/` に書く

- AI がその場で誤る可能性が高い具体ルール
- 順序
- 入出力
- 検証条件
- 禁止事項

### `docs/` に書く

- なぜそのルールがあるか
- どの文脈で生まれたか
- 旧体系比較
- 長い例
- 図や導入説明

## Skill 作成仕様との関係

現在の `SKILL.md` は Agent Skills の仕様に合わせて frontmatter を持ちます。

重要点:

- `name`
  - 親ディレクトリ名と一致
- `description`
  - 何をする skill か
  - いつ使う skill か

この仕様に合わせる理由は、単に形式を揃えるためではありません。
Agent が skill を選ぶ起点が、主に `name` と `description` だからです。

## Best Practices をどう反映したか

Agent Skills の best practices から、特に次を取り込んでいます。

1. 短い本体
   - runtime 文書を圧縮
2. progressive disclosure
   - 背景は `docs/` に退避
3. coherent units
   - rule、skill、template の責務を分離
4. defaults over menus
   - 標準フローを先に置く
5. procedures over declarations
   - 「何を出せ」より「どう進めるか」を優先

## 推奨の読む順番

1. `docs/AI-PLC-CORE-OVERVIEW.md`
2. `core/skills/ai-plc/README.md`
3. `core/rules/ai-plc-system.md`
4. `core/rules/ai-plc-adaptive.md`
5. `core/rules/ai-plc-session.md`
6. `core/skills/ai-plc/01-collection/SKILL.md`
7. `core/skills/ai-plc/02-inception/SKILL.md`
8. `core/skills/ai-plc/03-construction/SKILL.md`
9. `core/skills/ai-plc/04-operation/SKILL.md`
10. `core/skills/ai-plc/templates/roles/*.md`
11. `core/skills/ai-plc/templates/agents/*.md`

## 保守ルール

更新時は次を守るべきです。

1. runtime に説明を戻しすぎない
2. 同じルールを複数 skill に重複させない
3. 共通制約は `rules` に寄せる
4. 具体的な判断軸は `templates` に寄せる
5. 長い説明は `docs` に寄せる

## 今後の拡張ポイント

- `db-sync` を project-specific 拡張として分離
- `references/` を増やし、長いノウハウを progressive disclosure 化
- skill ごとの gotchas セクション追加
- 実タスクからのフィードバックで `description` を改善

## まとめ

AI-PLC は、AI に曖昧な大仕事を丸投げするための仕組みではありません。
Goal から成果物までの判断を、分解、実行、検証、反映まで含めて再利用可能な形にするための運用基盤です。
