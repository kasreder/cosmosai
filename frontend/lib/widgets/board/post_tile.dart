// File: frontend/lib/widgets/board/post_tile.dart
// Description: List tile widget summarizing a board post for the list-style board view.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/board_post.dart';
import '../../router/app_router.dart';

/// Displays a board post in list format with key stats.
class PostTile extends StatelessWidget {
  /// Creates a tile with the provided post data.
  const PostTile({super.key, required this.post});

  /// Post to render.
  final BoardPost post;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title),
      subtitle: Text('${post.authorNickname} · 조회 ${post.viewCount} · 좋아요 ${post.likeCount}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.goNamed(
        AppRouteNames.postDetail,
        pathParameters: <String, String>{
          'categorySegment': post.category.pathSegment,
          'postId': post.id,
        },
      ),
    );
  }
}
