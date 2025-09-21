// File: frontend/lib/screens/boards/board_list_screen.dart
// Description: List-style board screen rendering posts filtered by category with provider integration.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/board_category.dart';
import '../../providers/auth_provider.dart';
import '../../providers/board_provider.dart';
import '../../widgets/board/post_tile.dart';

/// Board list screen.
class BoardListScreen extends StatelessWidget {
  /// Creates the screen for the given category.
  const BoardListScreen({super.key, required this.category});

  /// Currently active category.
  final BoardCategory category;

  @override
  Widget build(BuildContext context) {
    final BoardProvider boardProvider = context.watch<BoardProvider>();
    final AuthProvider authProvider = context.watch<AuthProvider>();
    final List<BoardCategory> categories = BoardCategory.values;

    return Scaffold(
      appBar: AppBar(
        title: Text('게시판 · ${category.label}'),
        actions: <Widget>[
          if (!authProvider.isAuthenticated)
            IconButton(
              tooltip: '로그인',
              onPressed: () => context.push('/login'),
              icon: const Icon(Icons.login),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Text(
                  '${authProvider.currentUser!.nickname}님',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 56,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (BuildContext context, int index) {
                final BoardCategory value = categories[index];
                final bool isSelected = value == boardProvider.selectedCategory;
                return ChoiceChip(
                  label: Text(value.label),
                  selected: isSelected,
                  onSelected: (_) {
                    context.read<BoardProvider>().updateCategory(value);
                    context.go('/boards/${value.pathSegment}');
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: boardProvider.filteredPosts.length,
              itemBuilder: (BuildContext context, int index) {
                return PostTile(post: boardProvider.filteredPosts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
