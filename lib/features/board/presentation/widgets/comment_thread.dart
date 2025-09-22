// File: lib/features/board/presentation/widgets/comment_thread.dart | Description: 댓글 및 대댓글을 계층적으로 렌더링하는 위젯.
import 'package:flutter/material.dart';

import '../../../../models/comment_model.dart';

class CommentThread extends StatelessWidget {
  const CommentThread({
    super.key,
    required this.comments,
    this.depth = 0,
    this.onReply,
  });

  final List<CommentModel> comments;
  final int depth;
  final ValueChanged<CommentModel>? onReply;

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: comments.map((CommentModel comment) {
        return Padding(
          padding: EdgeInsets.only(left: depth * 16.0, top: 8, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(comment.authorNickname, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(width: 8),
                  Text(
                    '${comment.createdAt.hour.toString().padLeft(2, '0')}:${comment.createdAt.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  if (onReply != null)
                    TextButton(
                      onPressed: () => onReply?.call(comment),
                      child: const Text('답글'),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(comment.content),
              const Divider(height: 24),
              if (comment.replies.isNotEmpty)
                CommentThread(
                  comments: comment.replies,
                  depth: depth + 1,
                  onReply: onReply,
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
