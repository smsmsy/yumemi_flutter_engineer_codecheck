// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'git_hub_search_api_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiRepositoryHash() => r'79ae13e48524261b7362ae5a6a2ab82855d66d97';

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

/// See also [apiRepository].
@ProviderFor(apiRepository)
const apiRepositoryProvider = ApiRepositoryFamily();

/// See also [apiRepository].
class ApiRepositoryFamily extends Family<GitHubSearchApiRepository> {
  /// See also [apiRepository].
  const ApiRepositoryFamily();

  /// See also [apiRepository].
  ApiRepositoryProvider call(Dio dio) {
    return ApiRepositoryProvider(dio);
  }

  @override
  ApiRepositoryProvider getProviderOverride(
    covariant ApiRepositoryProvider provider,
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
  String? get name => r'apiRepositoryProvider';
}

/// See also [apiRepository].
class ApiRepositoryProvider extends Provider<GitHubSearchApiRepository> {
  /// See also [apiRepository].
  ApiRepositoryProvider(Dio dio)
    : this._internal(
        (ref) => apiRepository(ref as ApiRepositoryRef, dio),
        from: apiRepositoryProvider,
        name: r'apiRepositoryProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$apiRepositoryHash,
        dependencies: ApiRepositoryFamily._dependencies,
        allTransitiveDependencies:
            ApiRepositoryFamily._allTransitiveDependencies,
        dio: dio,
      );

  ApiRepositoryProvider._internal(
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
    GitHubSearchApiRepository Function(ApiRepositoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ApiRepositoryProvider._internal(
        (ref) => create(ref as ApiRepositoryRef),
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
    return _ApiRepositoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiRepositoryProvider && other.dio == dio;
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
mixin ApiRepositoryRef on ProviderRef<GitHubSearchApiRepository> {
  /// The parameter `dio` of this provider.
  Dio get dio;
}

class _ApiRepositoryProviderElement
    extends ProviderElement<GitHubSearchApiRepository>
    with ApiRepositoryRef {
  _ApiRepositoryProviderElement(super.provider);

  @override
  Dio get dio => (origin as ApiRepositoryProvider).dio;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
