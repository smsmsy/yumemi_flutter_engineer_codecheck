# 言語リソースの追加方法

多言語対応にて新しい言語や新規文言を追加する手順を説明します。

## 1. CSVファイルのメンテナンス

### 新規文言の追加

新しい文言を追加する場合は、[`strings.csv`](../lib/l10n/strings.csv) に新しい行を追加してください。

| ID | Description | EN | JA |
| - | - | - | - |
| hello | Hello message | Hello | こんにちは |
| goodbye | Goodbye message | Goodbye | さようなら |
| new_message | New message description | New message | 新しいメッセージ |

### 新しい言語の追加

新しい言語を追加する場合は、[`strings.csv`](../lib/l10n/strings.csv) のヘッダーに新しい言語（例: FR, IT など）を追加し、各行に翻訳を記入してください。

| ID | Description | EN | JA　| FR　|
| -| -| -| - | - |
| hello | Hello message | Hello | こんにちは | Bonjour |
| goodbye | Goodbye message | Goodbye | さようなら | Au revoir |

## 2. 多言語対応リソースの自動生成

[`l10n-generate.sh`](../tool/l10n_generate.sh)を実行して下さい。

```shell
sh l10n-generate.sh
```

---

### 補足: `l10n-generate.sh` の中身について

#### 1. CSVからARBファイルを自動生成する

[`gen_arb.dart`](../tool/gen_arb.dart)を実行することで各言語のarbファイルを自動生成できます。

```sh
dart run tool/gen_arb.dart
```

- `app_en.arb`, `app_ja.arb`, `app_fr.arb` などが `lib/l10n/` に出力されます。
- スクリプトの修正は不要です。言語列を追加するだけで対応できます。

#### 2. `flutter gen-l10n` で言語リソースファイル自動生成する

下記コマンドでローカライズ用Dartファイルを自動生成できます。

```terminal
flutter gen-l10n
```
