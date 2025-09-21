// File: frontend/lib/router/app_router.dart
// Description: GoRouter configuration enabling deep links and adaptive navigation shell layouts.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/board_category.dart';
import '../providers/board_provider.dart';
import '../screens/auth/login_screen.dart';
import '../screens/boards/board_gallery_screen.dart';
import '../screens/boards/board_list_screen.dart';
import '../screens/boards/post_detail_screen.dart';
import '../screens/boards/post_editor_screen.dart';
import '../screens/shell/adaptive_shell.dart';

/// Route names for readability.
class AppRouteNames {
  /// Login screen route name.
  static const String login = 'login';

  /// List board route name.
  static const String boardList = 'board-list';

  /// Gallery board route name.
  static const String boardGallery = 'board-gallery';

  /// Post detail route name.
  static const String postDetail = 'post-detail';

  /// Post editor route name.
  static const String postEditor = 'post-editor';
}

/// Builds the application router with navigation rail aware shell.
GoRouter createRouter(BoardProvider boardProvider) {
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/boards/${boardProvider.selectedCategory.pathSegment}',
    routes: <RouteBase>[
      GoRoute(
        name: AppRouteNames.login,
        path: '/login',
        builder: (BuildContext context, GoRouterState state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state, StatefulNavigationShell shell) {
          return AdaptiveShell(
            navigationShell: shell,
          );
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: AppRouteNames.boardList,
                path: '/boards/:categorySegment',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final String segment = state.pathParameters['categorySegment'] ??
                      boardProvider.selectedCategory.pathSegment;
                  final BoardCategory category =
                      BoardCategoryExtension.fromSegment(segment);
                  boardProvider.updateCategory(category);
                  return NoTransitionPage<void>(
                    child: BoardListScreen(category: category),
                  );
                },
                routes: <RouteBase>[
                  GoRoute(
                    name: AppRouteNames.postDetail,
                    path: 'post/:postId',
                    builder: (BuildContext context, GoRouterState state) {
                      final String id = state.pathParameters['postId']!;
                      return PostDetailScreen(postId: id);
                    },
                  ),
                  GoRoute(
                    name: AppRouteNames.postEditor,
                    path: 'edit/:postId',
                    builder: (BuildContext context, GoRouterState state) {
                      final String postId = state.pathParameters['postId']!;
                      return PostEditorScreen(postId: postId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                name: AppRouteNames.boardGallery,
                path: '/gallery',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return const NoTransitionPage<void>(
                    child: BoardGalleryScreen(),
                  );
                },
                routes: <RouteBase>[
                  GoRoute(
                    name: '${AppRouteNames.boardGallery}-${AppRouteNames.postDetail}',
                    path: 'post/:postId',
                    builder: (BuildContext context, GoRouterState state) {
                      final String id = state.pathParameters['postId']!;
                      return PostDetailScreen(postId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
