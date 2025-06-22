import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumemi_flutter_engineer_codecheck/domain/model/git_hub_search_api/repository.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/page/repositori_search_page.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/page/repository_details_page.dart';

final goRouterProvider = Provider<GoRouter>(
  (ref) => createGoRouter(),
);

class AppRoutes {
  static const root = '/';
  static const details = 'details';
}

GoRouter createGoRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.root,
        name: 'home',
        builder: (context, state) => const RepositorySearchPage(),
        routes: [
          GoRoute(
            path: AppRoutes.details,
            name: 'details',
            pageBuilder: (context, state) {
              final repository = state.extra! as Repository;
              return CustomTransitionPage(
                transitionDuration: const Duration(milliseconds: 500),
                reverseTransitionDuration: const Duration(milliseconds: 500),
                child: RepositoryDetailsPage(repository: repository),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
    ],
  );
}
