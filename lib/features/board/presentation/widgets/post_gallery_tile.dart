// File: lib/features/board/presentation/widgets/post_gallery_tile.dart | Description: 액자형(갤러리) 게시글 타일.
import 'package:flutter/material.dart';

import '../../../../models/post_model.dart';

class PostGalleryTile extends StatelessWidget {
  const PostGalleryTile({
    super.key,
    required this.post,
    required this.onTap,
  });

  final PostModel post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: post.imageUrls.isNotEmpty
                  ? Image.asset(post.imageUrls.first, fit: BoxFit.cover, width: double.infinity)
                  : Container(
                      color: Colors.blueGrey.shade100,
                      width: double.infinity,
                      child: const Icon(Icons.photo, size: 48),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(post.title, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
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
