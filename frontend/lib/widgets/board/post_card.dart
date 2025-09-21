// File: frontend/lib/widgets/board/post_card.dart
// Description: Card widget rendering a board post thumbnail for the gallery-style board view.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/board_post.dart';
import '../../router/app_router.dart';

/// Card styled widget for gallery posts.
class PostCard extends StatelessWidget {
  /// Creates a new card with the post data.
  const PostCard({super.key, required this.post});

  /// Post to render.
  final BoardPost post;

  @override
  Widget build(BuildContext context) {
    final String thumbnail = post.imageUrls.isNotEmpty ? post.imageUrls.first : '';
    return GestureDetector(
      onTap: () => context.goNamed(
        '${AppRouteNames.boardGallery}-${AppRouteNames.postDetail}',
        pathParameters: <String, String>{'postId': post.id},
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (thumbnail.isNotEmpty)
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  thumbnail,
                  fit: BoxFit.cover,
                ),
              )
            else
              const SizedBox(
                height: 160,
                child: Center(child: Icon(Icons.photo_library_outlined, size: 48)),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.authorNickname,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
