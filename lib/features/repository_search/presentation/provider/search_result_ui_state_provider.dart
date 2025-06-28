import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/widget/search_result_list_view.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/repository_providers.dart'
    as repo_providers;
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

part 'search_result_ui_state_provider.g.dart';

@Riverpod(keepAlive: true)
SearchResultUIState searchResultUIState(
  Ref ref, {
  required ScrollController scrollController,
}) {
  final queryString = ref.watch(
    repo_providers.gitHubSearchQueryNotifierProvider.select((e) => e.q),
  );
  final repositoriesAsyncValue = ref.watch(
    repo_providers.repositoriesSearchResultProvider,
  );
  return SearchResultUIState.build(
    queryString: queryString,
    repositoriesAsyncValue: repositoriesAsyncValue,
    scrollController: scrollController,
  );
}

sealed class SearchResultUIState extends ConsumerWidget {
  const SearchResultUIState({super.key});

  factory SearchResultUIState.build({
    required String queryString,
    required AsyncValue<List<Repository>> repositoriesAsyncValue,
    required ScrollController scrollController,
  }) {
    if (queryString.isEmpty) {
      return const QueryEmptyState();
    }
    if (repositoriesAsyncValue is AsyncError) {
      return const ErrorState();
    }
    if (repositoriesAsyncValue is AsyncData) {
      if (repositoriesAsyncValue.requireValue.isEmpty) {
        return const ListEmptyState();
      } else {
        return ListState(scrollController: scrollController);
      }
    }
    return const LoadingState();
  }

  FadeTransition transitionBuilder(Widget child, Animation<double> animation) =>
      FadeTransition(
        opacity: animation,
        child: child,
      );

  @override
  ValueKey<String> get key;

  Duration get duration;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Duration>('duration', duration));
  }
}

class QueryEmptyState extends SearchResultUIState {
  const QueryEmptyState({super.key});

  @override
  ValueKey<String> get key => const ValueKey('queryEmpty');

  @override
  Duration get duration => const Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      key: key,
      child: Text(
        AppLocalizations.of(context)?.inputKeyword ?? WordingData.inputKeyword,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class ListEmptyState extends SearchResultUIState {
  const ListEmptyState({super.key});

  @override
  ValueKey<String> get key => const ValueKey('listEmpty');

  @override
  Duration get duration => const Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      key: const ValueKey('listEmpty'),
      child: Text(
        AppLocalizations.of(context)?.noRepository ?? WordingData.noRepository,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class LoadingState extends SearchResultUIState {
  const LoadingState({super.key});

  @override
  ValueKey<String> get key => const ValueKey('loading');

  @override
  Duration get duration => const Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      key: ValueKey('loading'),
      child: CircularProgressIndicator(),
    );
  }
}

class ErrorState extends SearchResultUIState {
  const ErrorState({super.key});

  @override
  ValueKey<String> get key => const ValueKey('error');

  @override
  Duration get duration => const Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorString = ref.watch(
      repo_providers.repositoriesSearchResultProvider.select((e) => e.error),
    );
    return Center(
      key: key,
      child: Text(
        errorString.toString(),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class ListState extends SearchResultUIState {
  const ListState({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  ValueKey<String> get key => const ValueKey('list');

  @override
  Duration get duration => const Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      key: key,
      child: AdaptiveRepositoryListView(
        value: ref.watch(
          repo_providers.repositoriesSearchResultProvider.select(
            (e) => e.requireValue,
          ),
        ),
        scrollController: scrollController,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ScrollController>(
        'scrollController',
        scrollController,
      ),
    );
  }
}
