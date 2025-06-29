import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

part 'search_query_validator_provider.g.dart';

@riverpod
SearchQueryValidateStrings? Function(String?) searchQueryValidator(Ref ref) {
  return (value) {
    // 空文字は無効
    if (value == null || value.trim().isEmpty) {
      return SearchQueryValidateStrings.inputKeyword;
    }

    // 256文字制限（修飾子や演算子を除く）
    // ここではシンプルに全体長でチェック
    if (value.length > 256) {
      // contextが使えないため、WordingDataのみ利用
      return SearchQueryValidateStrings.searchQueryLength;
    }

    // AND/OR/NOT演算子の合計が5個を超えていないか
    final operatorRegExp = RegExp(r'\b(AND|OR|NOT)\b', caseSensitive: false);
    final operatorCount = operatorRegExp.allMatches(value).length;
    if (operatorCount > 5) {
      return SearchQueryValidateStrings.searchQueryOperator;
    }

    // 正常な場合はnullを返す
    return null;
  };
}

enum SearchQueryValidateStrings {
  inputKeyword(),
  searchQueryLength(),
  searchQueryOperator();

  const SearchQueryValidateStrings();

  String messageVia(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      // ローカライズが利用できない場合はデフォルトのメッセージを返す
      return switch (this) {
        SearchQueryValidateStrings.inputKeyword => WordingData.inputKeyword,
        SearchQueryValidateStrings.searchQueryLength =>
          WordingData.searchQueryLength,
        SearchQueryValidateStrings.searchQueryOperator =>
          WordingData.searchQueryOperator,
      };
    }
    return switch (this) {
      SearchQueryValidateStrings.inputKeyword => l10n.inputKeyword,
      SearchQueryValidateStrings.searchQueryLength => l10n.searchQueryLength,
      SearchQueryValidateStrings.searchQueryOperator =>
        l10n.searchQueryOperator,
    };
  }
}
