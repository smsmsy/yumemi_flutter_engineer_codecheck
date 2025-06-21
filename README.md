# yumemi_flutter_engineer_codecheck

本プロジェクトは[株式会社ゆめみ Flutter エンジニアコードチェック課題](https://github.com/yumemi-inc/flutter-engineer-codecheck)を実装したものです。

## コーディングガイドについて

[docs/styles_guideline.md](docs/styles_guideline.md) をご確認ください。

## 動作確認方法

### Riverpod の自動生成

Riverpod のコード自動生成には下記コマンドを使用してください。

```terminal
flutter pub run build_runner watch --delete-conflicting-outputs
```

- パッケージ追加などの影響でたまに失敗していることがあるので、気がついたら再実行してください。
- `--delete-conflicting-outputs` オプションは競合するファイルを自動で削除します。

### 多言語対応（l10n）ファイルの生成

言語ファイル（lib/l10n/*.arb）を編集・追加した場合は、下記コマンドでローカライズ用Dartファイルを再生成してください。

```terminal
flutter gen-l10n
```

### デバッグビルド

動作確認するためには下記コマンドを順に実行してください。

```terminal
flutter pub get
flutter run
```
