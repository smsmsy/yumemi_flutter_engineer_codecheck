# レビューポイント

## 1. 本プロジェクトの概要

- Flutter で GitHub リポジトリをキーワード検索し、一覧表示・詳細表示を行うアプリケーション
- 検索には GitHub REST API を Dio を用いて直接呼び出し、特定の外部パッケージは利用せず自前で実装
- 状態管理に Riverpod を採用
- Material Design 準拠の UI

## 2. アピールポイント

- FlutterらしいHTTPの処理方法(flutter_riverpod/freezed/json_serializable)
- ドキュメントの充実(`README.md`、`ARCHITECTURE.md`、`styles_guideline.md` など)
- Flaky Testingを極力省いた効果的なテスト構成
  - Flaky Testing(実際にリクエストを叩くテストなど)は、手動実行できるようにはしている
- Material Design に基づいた UI 設計（過剰すぎない程度のアニメーション）
- `l10n.yaml`/ARB を活用した多言語対応の構成 と csv ファイルからの文言データ読み込み効率化スクリプト
- Feature-first 構成で、機能ごとに domain/infrastructure/presentation 等のレイヤーを分割
  - AI Codingとの相性を考えても Feature-first が好ましいと考える
- ThemeData経由で全体的なUIの管理を行っている
- GoRouter を用いた画面遷移の実装(サインイン状態によるリダイレクト制御)
  - GitHub Authに対するリダイレクトの実装など
- ユニットテスト／UI テストの導入しやすい依存性注入を意識した構成
- CI/CD が整備されており、Pull Request 作成時に自動実行される
  - CI (`ci.yaml`) : 静的解析・テスト・Android/iOS/Webのビルドに通ることを満たすことを確認
  - CD (`deploy.yaml`） : GitHub Pages (仮のデプロイ環境) への自動デプロイ
- 適切なコミット粒度（基本的にビルドできる単位）と Git ブランチ運用(GitHub flow like)
  - デプロイのために release ブランチを仕込んでいるため GitHub flow "like"
- ＋αな機能を実装した
  - GitHub認証を利用したログイン機能とアクセストークンの利用が可能（iOSのみ）
  - 検索履歴の保存機能

## 3. 注意点／改善余地

- Web/AndoirdではGitHub認証が未実装のため、アクセストークンを手動で設定する必要がある
  - 時間が足りませんでした... orz
- エラー発生時の UI フィードバックがやや不足気味であること
  - 例：API 呼び出し失敗時のエラーメッセージ表示がない
- テストコードのカバレッジ監視システムが構築できていないため、テストの網羅性が不明
  - カバレッジ○○%などの数値が大切なのではなく、カバレッジを監視できないことが問題点
- 画面回転・異なる画面サイズ対応
  - 特にWeb版全画面サイズは見にくい
- アニメーションのパフォーマンス最適化余地ありそう
- 2025/6/30時点で CI/CD が通らなくなっている。。。
  - サインイン画面の実装に伴ってビルドが通らない
  - 設定を見直す必要がある（Web/android/ビルド環境上のスクリプト設定など）

## 4. その他アピールポイント

- 独自スクリプト（`tool/gen_arb.dart`、`l10n_generate.sh`）で自動化にも配慮
- `custom_lint.log` を含めたカスタム lint 設定の導入
- Firebase 連携（`firebase_options.dart`）やプラットフォーム別設定ファイル整備
- 資料（`ARCHITECTURE.md`、`styles_guideline.md`）が充実し、チーム開発準備が整っている
