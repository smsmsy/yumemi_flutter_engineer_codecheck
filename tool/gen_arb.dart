import 'dart:convert';
import 'dart:io';

import 'package:simple_logger/simple_logger.dart';

void main() async {
  final logger = SimpleLogger();
  logger.info('arbファイルを生成します');

  // --------------------------------------
  // CSVファイルの読み込み
  // --------------------------------------
  final lines = await readCsvLines(logger);
  if (lines.isEmpty) {
    logger.warning('CSVファイルが空です');
    exit(1);
  }
  if (lines.length < 2) {
    logger.warning('CSVファイルにデータがありません');
    exit(1);
  }

  // --------------------------------------
  // CSVのヘッダーを取得
  // --------------------------------------
  final header = lines.first.split(',');
  const idIndex = 0;
  const descIndex = 1;

  // --------------------------------------
  // 言語列を動的に取得（ID,Description以外）
  // --------------------------------------
  final languageIndices = <String, int>{};
  for (var i = 2; i < header.length; i++) {
    final lang = header[i].trim();
    if (lang.isNotEmpty) {
      languageIndices[lang] = i;
    }
  }
  if (languageIndices.isEmpty) {
    logger.warning('言語列が見つかりません');
    exit(1);
  }
  if (!languageIndices.containsKey('EN')) {
    logger.warning('EN列が見つかりません');
    exit(1);
  }

  // --------------------------------------
  // 言語ごとにMapを用意
  // --------------------------------------
  final arbMaps = <String, Map<String, dynamic>>{};
  for (final lang in languageIndices.keys) {
    arbMaps[lang] = <String, dynamic>{};
  }

  logger.info('対象の文言数: ${lines.length - 1}');

  // --------------------------------------
  // CSVの各行を処理
  // --------------------------------------
  for (final line in lines.skip(1)) {
    final row = _parseCsvLine(line);
    if (row.length < header.length) {
      logger.warning('行のデータが不完全です: \nheader:\t$header\nline:\t$line');
      exit(1);
    }
    final id = row[idIndex];
    final desc = row[descIndex];

    for (final entry in languageIndices.entries) {
      final lang = entry.key;
      final idx = entry.value;
      final value = row[idx];
      if (lang == 'EN') {
        arbMaps[lang]![id] = value;
        arbMaps[lang]!['@$id'] = {'description': desc};
      } else {
        arbMaps[lang]![id] = value;
      }
    }
  }

  // --------------------------------------
  // arbファイル出力
  // --------------------------------------
  for (final lang in languageIndices.keys) {
    final fileName = 'lib/l10n/app_${lang.toLowerCase()}.arb';
    await File(fileName).writeAsString(_arbString(arbMaps[lang]!));
    logger.info('$fileName を生成しました');
  }
  exit(0);
}

/// CSVファイルを読み込み、各行をリストとして返す。
Future<List<String>> readCsvLines(SimpleLogger logger) async {
  const csvFilePath = 'lib/l10n/strings.csv';
  if (!File(csvFilePath).existsSync()) {
    logger.warning('CSVファイルが存在しません');
    exit(1);
  }
  final csvFile = File(csvFilePath);
  final lines = await csvFile.readAsLines();
  return lines;
}

/// CSVの1行をカンマで分割し、リストとして返す。
List<String> _parseCsvLine(String line) {
  // シンプルなカンマ区切り（ダブルクォート未対応）
  return line.split(',');
}

/// MapをARB形式の文字列に変換する。
String _arbString(Map<String, dynamic> map) {
  return const JsonEncoder.withIndent('  ').convert(map);
}
