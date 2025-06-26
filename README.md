# yumemi_flutter_engineer_codecheck

本プロジェクトは[株式会社ゆめみ Flutter エンジニアコードチェック課題](https://github.com/yumemi-inc/flutter-engineer-codecheck)を実装したものです。

## コーディングガイドについて

[styles_guideline.md](documents/styles_guideline.md) をご確認ください。

## 動作確認方法

動作確認するためには下記コマンドを順に実行してください。

```terminal
flutter pub get
flutter run
```

## Riverpod/Freezed/JsonSerialization の自動生成

上記のようなbuild_runnerによるコード自動生成を実行するには下記コマンドを使用してください。

```terminal
flutter pub run build_runner watch --delete-conflicting-outputs
```

- パッケージ追加などの影響でたまに失敗していることがあるので、気がついたら再実行してください。
- `--delete-conflicting-outputs` オプションは競合するファイルを自動で削除します。

## 多言語対応（l10n）ファイルの自動生成

言語ファイル（lib/l10n/*.arb）を編集・追加した場合は、下記のバッチファイルを実行して下さい。

```shell
sh l10n-generate.sh
```

さらに詳しい言語追加対応については、 [how-to-add-strings.md](documents/how-to-add-strings.md) をご確認ください。
