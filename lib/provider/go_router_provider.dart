import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yumemi_flutter_engineer_codecheck/view/page/search_page.dart';

final goRouterProvider = Provider<GoRouter>(
  (ref) => createGoRouter(),
);

class AppRoutes {
  static const root = '/';
}

GoRouter createGoRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: AppRoutes.root,
        name: 'home',
        builder: (context, state) => const SearchPage(),
      ),
    ],
  );
}
