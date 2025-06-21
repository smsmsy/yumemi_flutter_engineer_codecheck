#!/bin/bash
# l10n_generate.sh
# 多言語対応ファイルの自動生成スクリプト
# 1. CSVからarbファイルを生成
# 2. arbファイルからDartローカライズコードを生成

set -e

echo "[1/2] CSVからarbファイルを生成..."
dart run tool/gen_arb.dart

if [ $? -ne 0 ]; then
  echo "arbファイル生成に失敗しました" >&2
  exit 1
fi

echo "[2/2] arbファイルからDartローカライズコードを生成..."
flutter gen-l10n

if [ $? -ne 0 ]; then
  echo "flutter gen-l10n に失敗しました" >&2
  exit 2
fi

echo "l10nファイル生成が完了しました！"
