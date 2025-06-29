import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/git_hub_search_query.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/domain/entity/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/page/repository_search/widget/search_result_list_view.dart';
import 'package:yumemi_flutter_engineer_codecheck/features/repository_search/presentation/provider/repository_providers.dart';
import 'package:yumemi_flutter_engineer_codecheck/l10n/app_localizations.dart';
import 'package:yumemi_flutter_engineer_codecheck/static/wording_data.dart';

part 'search_result_ui_state_provider.g.dart';

@Riverpod(keepAlive: true)
SearchResultUIState searchResultUIState(Ref ref) {
  final queryString = ref.watch(
    gitHubSearchQueryNotifierProvider.select((e) => e.q),
  );
  final repositoriesAsyncValue = ref.watch(
    repositoriesSearchResultProvider,
  );
  return SearchResultUIState.build(
    queryString: queryString,
    repositoriesAsyncValue: repositoriesAsyncValue,
  );
}

sealed class SearchResultUIState extends ConsumerWidget {
  const SearchResultUIState({super.key});

  factory SearchResultUIState.build({
    required String queryString,
    required AsyncValue<List<Repository>> repositoriesAsyncValue,
  }) {
    if (queryString.isEmpty) {
      return const _QueryEmptyState();
    }
    if (repositoriesAsyncValue is AsyncError) {
      return const _ErrorState();
    }
    if (repositoriesAsyncValue is AsyncData) {
      if (repositoriesAsyncValue.requireValue.isEmpty) {
        return const _ListEmptyState();
      } else {
        return const _ListState();
      }
    }
    return const _LoadingState();
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

class _QueryEmptyState extends SearchResultUIState {
  const _QueryEmptyState();

  @override
  ValueKey<String> get key => const ValueKey('queryEmpty');

  @override
  Duration get duration => Durations.short3;

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

class _ListEmptyState extends SearchResultUIState {
  const _ListEmptyState();

  @override
  ValueKey<String> get key => const ValueKey('listEmpty');

  @override
  Duration get duration => Durations.short3;

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

class _LoadingState extends SearchResultUIState {
  const _LoadingState();

  @override
  ValueKey<String> get key => const ValueKey('loading');

  @override
  Duration get duration => Durations.short3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Center(
      key: ValueKey('loading'),
      child: CircularProgressIndicator(),
    );
  }
}

class _ErrorState extends SearchResultUIState {
  const _ErrorState();

  @override
  ValueKey<String> get key => const ValueKey('error');

  @override
  Duration get duration => Durations.short3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorString = ref.watch(
      repositoriesSearchResultProvider.select((e) => e.error),
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

class _ListState extends SearchResultUIState {
  const _ListState();

  @override
  ValueKey<String> get key => const ValueKey('list');

  @override
  Duration get duration => Durations.medium4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HookBuilder(
      builder: (context) {
        final scrollController = useScrollController();
        return Center(
          key: key,
          child: AdaptiveRepositoryListView(
            value: ref.watch(
              repositoriesSearchResultProvider.select(
                (e) => e.requireValue,
              ),
            ),
            scrollController: scrollController,
          ),
        );
      },
    );
  }
}
