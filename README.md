# yumemi_flutter_engineer_codecheck

- [yumemi\_flutter\_engineer\_codecheck](#yumemi_flutter_engineer_codecheck)
  - [概要](#概要)
  - [開発環境](#開発環境)
  - [動作確認方法](#動作確認方法)
    - [アプリを起動する手順](#アプリを起動する手順)
    - [Riverpod/Freezed/JsonSerialization の自動生成](#riverpodfreezedjsonserialization-の自動生成)
    - [多言語対応（l10n）ファイルの自動生成](#多言語対応l10nファイルの自動生成)
  - [開発手順について](#開発手順について)
    - [コーディングガイドについて](#コーディングガイドについて)
    - [アプリの機能について](#アプリの機能について)
  - [アプリの設計について](#アプリの設計について)
    - [GitHub Copilotによる開発支援について](#github-copilotによる開発支援について)
      - [インストラクションファイル](#インストラクションファイル)
      - [プロンプトファイル](#プロンプトファイル)

## 概要

本プロジェクトは[株式会社ゆめみ Flutter エンジニアコードチェック課題](https://github.com/yumemi-inc/flutter-engineer-codecheck)を実装したものです。

下記の機能を実装しています。

- GitHubリポジトリの検索機能
- リポジトリの詳細情報表示機能
- 検索履歴機能
- テーマモードの変更機能
- OSSライセンス表示機能

## 開発環境

2025/6/28時点での開発環境は以下の通りです。

| 環境名 | バージョン | 備考 |
| --- | --- | --- |
| Flutter SDK | 3.32.4 | fvmを利用 |
| Dart SDK | 3.8.1 | fvmを利用 |
| macOS | Sequoia 15.5（24F74） | |
| Xcode | 16.4 (16F6) | |
| Android Studio | 2024.1.2 | |
| Visual Studio Code | 1.101.2 | 随時更新 |

## 動作確認方法

### アプリを起動する手順

前提として Flutter SDKがインストールされていて、`flutter doctor` コマンドによって環境が整っていることを確認してください。

その上で、動作確認するためには下記コマンドを順に実行してください。(環境によって異なる内容は適宜読み替えてください)

```bash
# アプリを自分の環境にクローンする (例 : HTTPS)
git clone https://github.com/smsmsy/yumemi_flutter_engineer_codecheck.git

# アプリが置いてある場所までディレクトリ移動する
cd yumemi_flutter_engineer_codecheck

# アプリが導入しているパッケージ導入
flutter pub get

# アプリの起動
flutter run
```

### Riverpod/Freezed/JsonSerialization の自動生成

本プロジェクトでは、[`build_runner`](https://pub.dev/packages/build_runner) によって、プロダクトコードを自動生成しています。  

例えば下記のパッケージにおいて、コード生成を行っています。

- [`riverpod`](https://pub.dev/packages/riverpod)
- [`freezed`](https://pub.dev/packages/freezed)
- [`json_serializable`](https://pub.dev/packages/json_serializable)

上記が関わるコードを修正した後など、コード自動生成を行うためには、下記コマンドを使用してください。

```bash
# プロダクトコードの自動生成する
# コードの変更を監視し、変更があれば自動で再生成する
#  (競合するファイルがある場合は削除して再生成するオプション付き)
dart pub run build_runner watch --delete-conflicting-outputs
```

> このコマンドではコードの変更を監視し自動的にコード生成が行われますが、パッケージ追加などの影響でたまに失敗していることがあるので、気がついたら再実行してください。

### 多言語対応（l10n）ファイルの自動生成

言語ファイル（lib/l10n/*.arb）を編集・追加した場合は、下記のバッチファイルを実行して下さい。

```bash
# 多言語対応のファイルを自動生成する
sh l10n-generate.sh
```

詳しい言語追加対応については [how-to-add-strings.md](documents/how-to-add-strings.md) をご確認ください。

## 開発手順について

### コーディングガイドについて

基本的には、Dart公式ドキュメントである [Effective Dart](https://dart.dev/effective-dart) に従って実装します。

詳しいコーディングガイドについては [styles_guideline.md](documents/styles_guideline.md) をご確認ください。

### アプリの機能について

本プロジェクトでは、以下の機能を実装しています。

- GitHubリポジトリの検索機能
- リポジトリの詳細情報表示機能
- 検索履歴機能
- テーマモードの変更機能
- OSSライセンス表示機能

詳しい内容やスクリーンショットについては [features.md](documents/features.md) をご確認ください。

## アプリの設計について

本プロジェクトは「feature-first」構成で、機能ごとにdomain/infrastructure/presentation等のレイヤーを分割し、単方向データフローとRiverpodによる状態管理を徹底しています。  
UI・API・ドメインロジック・多言語対応・テストなども、拡張性と可読性を重視したディレクトリ構成・設計方針に基づいています。

詳しい設計情報については [ARCHITECTURE.md](documents/ARCHITECTURE.md) をご確認ください。

### GitHub Copilotによる開発支援について

本プロジェクトでは GitHub Copilotを利用して開発を行っています。

GitHub Copilotとの開発を効率化するためにいくつかの機能を導入しています。

#### インストラクションファイル

GitHub Copilotに対して、プロジェクトの目的や開発方針を伝えるためのインストラクションファイルを用意しています。

このファイルは、GitHub Copilotがプロジェクトのコンテキストを理解し、より適切なコード提案を行うためのものです。

内容については [base.instructions.md](.github/instructions/base.instructions.md) を参照してください。

#### プロンプトファイル

GitHub Copilotに対して、特定の機能やコードの実装方法を指示するためのプロンプトファイルを用意しています。

このファイルは、GitHub Copilotが特定のタスクに対してより具体的な提案を行うためのものです。

プロンプトファイルは GitHub Copilot のチャット入力欄にて `/` を入力することで、選択可能です。

下記のようなプロンプトファイルを用意しています。

- [add_comments.prompt.md](.github/prompts/add_comments.prompt.md): 現在開いているファイルの「クラス」・「関数」・「メソッド」・「外部公開変数」に対して、docstringコメントを日本語で追加します。
- [add_wording.prompt.md](.github/prompts/add_wording.prompt.md): プロンプトに入力された文言について翻訳文言対応を行い、コードに直接書かれた文言を翻訳文言を利用するようにを更新します。
- [commit_done_files.prompt.md](.github/prompts/commit_done_files.prompt.md): 現在のブランチ内で修正を行なったファイルに対して、どのような変更が行われたかを調査し、コミットメッセージを入力し、コミットを行います。
- [fix_tests.prompt.md](.github/prompts/fix_tests.prompt.md): 失敗しているテストに対して、原因解析・修正・テスト実行をループし、全てのテストが通ることを確認します。
- [write_pull_request.prompt.md](.github/prompts/write_pull_request.prompt.md): 現在のブランチで行われた変更を取りまとめ、プルリクエストの内容に貼り付けられる形の文章を作成します。
- [write_test.prompt.md](.github/prompts/write_test.prompt.md): 現在開いているファイルの「クラス」・「関数」・「メソッド」に対して、テストコードを追加します。
