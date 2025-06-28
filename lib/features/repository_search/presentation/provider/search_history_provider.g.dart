// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchHistoryHash() => r'875616db5678f11ed1c1494e7f227a9a7ad91be9';

/// 検索履歴を管理するRiverpodプロバイダのクラス。
///
/// 検索履歴の保存・取得・追加・クリアなどの機能を提供します。
///
/// Copied from [SearchHistory].
@ProviderFor(SearchHistory)
final searchHistoryProvider =
    AutoDisposeAsyncNotifierProvider<SearchHistory, List<String>>.internal(
      SearchHistory.new,
      name: r'searchHistoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$searchHistoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchHistory = AutoDisposeAsyncNotifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
