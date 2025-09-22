// File: lib/app/router/app_router.dart | Description: go_router 설정과 딥링크 라우팅 구성.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/board/presentation/screens/board_gallery_screen.dart';
import '../../features/board/presentation/screens/board_list_screen.dart';
import '../../features/board/presentation/screens/post_detail_screen.dart';
import '../../features/board/presentation/screens/post_editor_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../models/board_category.dart';
import '../../models/post_model.dart';
import '../widgets/scaffold_with_nested_navigation.dart';
import 'app_route.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter();

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoute.home.path,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: '/auth',
        name: 'auth',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoute.postEditor.path,
        name: AppRoute.postEditor.name,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          final Object? extra = state.extra;
          BoardCategory category = BoardCategory.free;
          PostModel? post;
          if (extra is BoardCategory) {
            category = extra;
          } else if (extra is PostModel) {
            post = extra;
            category = post.category;
          } else if (extra is Map<String, Object?>) {
            category = extra['category'] as BoardCategory? ?? BoardCategory.free;
            post = extra['post'] as PostModel?;
          }
          return PostEditorScreen(category: category, post: post);
        },
      ),
      GoRoute(
        path: AppRoute.postDetail.path,
        name: AppRoute.postDetail.name,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state) {
          final String postId = state.pathParameters['postId']!;
          final PostModel? post = state.extra as PostModel?;
          return PostDetailScreen(postId: postId, initialPost: post);
        },
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.home.path,
                name: AppRoute.home.name,
                builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.news.path,
                name: AppRoute.news.name,
                builder: (BuildContext context, GoRouterState state) => const BoardListScreen(category: BoardCategory.news),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.free.path,
                name: AppRoute.free.name,
                builder: (BuildContext context, GoRouterState state) => const BoardListScreen(category: BoardCategory.free),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.record.path,
                name: AppRoute.record.name,
                builder: (BuildContext context, GoRouterState state) => const BoardGalleryScreen(category: BoardCategory.record),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.notice.path,
                name: AppRoute.notice.name,
                builder: (BuildContext context, GoRouterState state) => const BoardListScreen(category: BoardCategory.notice),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoute.settings.path,
                name: AppRoute.settings.name,
                builder: (BuildContext context, GoRouterState state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
