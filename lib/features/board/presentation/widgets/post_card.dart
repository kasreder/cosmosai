// File: lib/features/board/presentation/widgets/post_card.dart | Description: 리스트형 게시글 카드를 구성하는 위젯.
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../../models/post_model.dart';
import '../../../../providers/view_count_provider.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.viewCountProvider,
  });

  final PostModel post;
  final VoidCallback onTap;
  final ViewCountProvider viewCountProvider;

  @override
  Widget build(BuildContext context) {
    final int viewCount = viewCountProvider.getViewCount(post.id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(post.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              HtmlWidget(
                post.content,
                textStyle: Theme.of(context).textTheme.bodyMedium,
                enableCaching: true,
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  const Icon(Icons.visibility, size: 16),
                  const SizedBox(width: 4),
                  Text('$viewCount'),
                  const SizedBox(width: 12),
                  const Icon(Icons.thumb_up_alt_outlined, size: 16),
                  const SizedBox(width: 4),
                  Text('${post.likeCount}'),
                  const SizedBox(width: 12),
                  const Icon(Icons.thumb_down_alt_outlined, size: 16),
                  const SizedBox(width: 4),
                  Text('${post.dislikeCount}'),
                  const Spacer(),
                  Text(
                    '${post.createdAt.year}.${post.createdAt.month.toString().padLeft(2, '0')}.${post.createdAt.day.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
