// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_ui_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchResultUIStateHash() =>
    r'2fd3a2be3e302645f5c5746acf87b308d9c3d3cd';

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

/// See also [searchResultUIState].
@ProviderFor(searchResultUIState)
const searchResultUIStateProvider = SearchResultUIStateFamily();

/// See also [searchResultUIState].
class SearchResultUIStateFamily extends Family<SearchResultUIState> {
  /// See also [searchResultUIState].
  const SearchResultUIStateFamily();

  /// See also [searchResultUIState].
  SearchResultUIStateProvider call({
    required ScrollController scrollController,
  }) {
    return SearchResultUIStateProvider(scrollController: scrollController);
  }

  @override
  SearchResultUIStateProvider getProviderOverride(
    covariant SearchResultUIStateProvider provider,
  ) {
    return call(scrollController: provider.scrollController);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchResultUIStateProvider';
}

/// See also [searchResultUIState].
class SearchResultUIStateProvider extends Provider<SearchResultUIState> {
  /// See also [searchResultUIState].
  SearchResultUIStateProvider({required ScrollController scrollController})
    : this._internal(
        (ref) => searchResultUIState(
          ref as SearchResultUIStateRef,
          scrollController: scrollController,
        ),
        from: searchResultUIStateProvider,
        name: r'searchResultUIStateProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$searchResultUIStateHash,
        dependencies: SearchResultUIStateFamily._dependencies,
        allTransitiveDependencies:
            SearchResultUIStateFamily._allTransitiveDependencies,
        scrollController: scrollController,
      );

  SearchResultUIStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.scrollController,
  }) : super.internal();

  final ScrollController scrollController;

  @override
  Override overrideWith(
    SearchResultUIState Function(SearchResultUIStateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchResultUIStateProvider._internal(
        (ref) => create(ref as SearchResultUIStateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        scrollController: scrollController,
      ),
    );
  }

  @override
  ProviderElement<SearchResultUIState> createElement() {
    return _SearchResultUIStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchResultUIStateProvider &&
        other.scrollController == scrollController;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, scrollController.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchResultUIStateRef on ProviderRef<SearchResultUIState> {
  /// The parameter `scrollController` of this provider.
  ScrollController get scrollController;
}

class _SearchResultUIStateProviderElement
    extends ProviderElement<SearchResultUIState>
    with SearchResultUIStateRef {
  _SearchResultUIStateProviderElement(super.provider);

  @override
  ScrollController get scrollController =>
      (origin as SearchResultUIStateProvider).scrollController;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
