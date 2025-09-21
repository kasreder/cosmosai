// File: frontend/lib/screens/shell/adaptive_shell.dart
// Description: Adaptive scaffold that switches between NavigationRail and NavigationBar using ScaffoldWithNavigationRail.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/board_category.dart';
import '../../providers/board_provider.dart';

/// Adaptive shell for the entire application.
class AdaptiveShell extends StatelessWidget {
  /// Creates the adaptive shell with navigation support.
  const AdaptiveShell({super.key, required this.navigationShell});

  /// Stateful navigation shell from go_router.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool useRail = constraints.maxWidth >= 960;
        final Widget body = navigationShell;
        if (useRail) {
          // Wide layout using ScaffoldWithNavigationRail for desktop/web.
          return ScaffoldWithNavigationRail(
            body: body,
            navigationRail: NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (int index) {
                navigationShell.goBranch(index,
                    initialLocation: index == navigationShell.currentIndex);
              },
              labelType: NavigationRailLabelType.selected,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.list_alt_outlined),
                  selectedIcon: Icon(Icons.list_alt),
                  label: Text('리스트'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.photo_library_outlined),
                  selectedIcon: Icon(Icons.photo_library),
                  label: Text('액자형'),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _openEditor(context),
              icon: const Icon(Icons.edit),
              label: const Text('글 작성'),
            ),
          );
        }
        // Compact layout for mobile screens.
        return Scaffold(
          body: body,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openEditor(context),
            icon: const Icon(Icons.edit),
            label: const Text('글 작성'),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (int index) {
              navigationShell.goBranch(index,
                  initialLocation: index == navigationShell.currentIndex);
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.list_alt_outlined),
                selectedIcon: Icon(Icons.list_alt),
                label: '리스트',
              ),
              NavigationDestination(
                icon: Icon(Icons.photo_library_outlined),
                selectedIcon: Icon(Icons.photo_library),
                label: '액자형',
              ),
            ],
          ),
        );
      },
    );
  }

  /// Opens the post editor route relative to the current branch.
  void _openEditor(BuildContext context) {
    final BoardCategory category = context.read<BoardProvider>().selectedCategory;
    final String segment = category.pathSegment;
    context.push('/boards/$segment/edit/new');
  }
}
