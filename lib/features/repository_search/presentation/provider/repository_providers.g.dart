// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$githubRepositoryHash() => r'9e52b78198bc626ef458f138b5c75d224549bf86';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// GitHubリポジトリの具象実装を提供するプロバイダー
///
/// DIコンテナとしてRiverpodを使用し、依存関係を管理
///
/// Copied from [githubRepository].
@ProviderFor(githubRepository)
const githubRepositoryProvider = GithubRepositoryFamily();

/// GitHubリポジトリの具象実装を提供するプロバイダー
///
/// DIコンテナとしてRiverpodを使用し、依存関係を管理
///
/// Copied from [githubRepository].
class GithubRepositoryFamily extends Family<GitHubSearchApiRepository> {
  /// GitHubリポジトリの具象実装を提供するプロバイダー
  ///
  /// DIコンテナとしてRiverpodを使用し、依存関係を管理
  ///
  /// Copied from [githubRepository].
  const GithubRepositoryFamily();

  /// GitHubリポジトリの具象実装を提供するプロバイダー
  ///
  /// DIコンテナとしてRiverpodを使用し、依存関係を管理
  ///
  /// Copied from [githubRepository].
  GithubRepositoryProvider call(Dio dio) {
    return GithubRepositoryProvider(dio);
  }

  @override
  GithubRepositoryProvider getProviderOverride(
    covariant GithubRepositoryProvider provider,
  ) {
    return call(provider.dio);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'githubRepositoryProvider';
}

/// GitHubリポジトリの具象実装を提供するプロバイダー
///
/// DIコンテナとしてRiverpodを使用し、依存関係を管理
///
/// Copied from [githubRepository].
class GithubRepositoryProvider extends Provider<GitHubSearchApiRepository> {
  /// GitHubリポジトリの具象実装を提供するプロバイダー
  ///
  /// DIコンテナとしてRiverpodを使用し、依存関係を管理
  ///
  /// Copied from [githubRepository].
  GithubRepositoryProvider(Dio dio)
    : this._internal(
        (ref) => githubRepository(ref as GithubRepositoryRef, dio),
        from: githubRepositoryProvider,
        name: r'githubRepositoryProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$githubRepositoryHash,
        dependencies: GithubRepositoryFamily._dependencies,
        allTransitiveDependencies:
            GithubRepositoryFamily._allTransitiveDependencies,
        dio: dio,
      );

  GithubRepositoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dio,
  }) : super.internal();

  final Dio dio;

  @override
  Override overrideWith(
    GitHubSearchApiRepository Function(GithubRepositoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GithubRepositoryProvider._internal(
        (ref) => create(ref as GithubRepositoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dio: dio,
      ),
    );
  }

  @override
  ProviderElement<GitHubSearchApiRepository> createElement() {
    return _GithubRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GithubRepositoryProvider && other.dio == dio;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dio.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GithubRepositoryRef on ProviderRef<GitHubSearchApiRepository> {
  /// The parameter `dio` of this provider.
  Dio get dio;
}

class _GithubRepositoryProviderElement
    extends ProviderElement<GitHubSearchApiRepository>
    with GithubRepositoryRef {
  _GithubRepositoryProviderElement(super.provider);

  @override
  Dio get dio => (origin as GithubRepositoryProvider).dio;
}

String _$repositoriesSearchResultHash() =>
    r'9c4150d4a3bb3e0d44d904cd54ef0513788527d7';

/// リポジトリ検索結果を提供するプロバイダー
///
/// ユーザーの検索クエリに基づいてリポジトリを取得
/// デバウンス機能付きHTTPクライアントを使用してAPI呼び出しを最適化
///
/// Copied from [repositoriesSearchResult].
@ProviderFor(repositoriesSearchResult)
final repositoriesSearchResultProvider =
    AutoDisposeFutureProvider<List<Repository>>.internal(
      repositoriesSearchResult,
      name: r'repositoriesSearchResultProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$repositoriesSearchResultHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RepositoriesSearchResultRef =
    AutoDisposeFutureProviderRef<List<Repository>>;
String _$gitHubSearchQueryNotifierHash() =>
    r'745bb2a26f8d0a5ab6a491b1922a482ecae2e5c2';

/// GitHub検索クエリの状態管理プロバイダー
///
/// ユーザーの検索入力を管理し、UIレイヤーから利用される
///
/// Copied from [GitHubSearchQueryNotifier].
@ProviderFor(GitHubSearchQueryNotifier)
final gitHubSearchQueryNotifierProvider =
    NotifierProvider<GitHubSearchQueryNotifier, GitHubSearchQuery>.internal(
      GitHubSearchQueryNotifier.new,
      name: r'gitHubSearchQueryNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$gitHubSearchQueryNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GitHubSearchQueryNotifier = Notifier<GitHubSearchQuery>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
