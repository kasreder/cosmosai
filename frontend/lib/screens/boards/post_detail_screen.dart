// File: frontend/lib/screens/boards/post_detail_screen.dart
// Description: Post detail screen showing HTML content, attachments, and nested comments with reply capability.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/board_comment.dart';
import '../../providers/auth_provider.dart';
import '../../providers/board_provider.dart';
import '../../router/app_router.dart';

/// Detail screen for a single post.
class PostDetailScreen extends StatefulWidget {
  /// Creates the detail screen for the provided post.
  const PostDetailScreen({super.key, required this.postId});

  /// Identifier of the post to show.
  final String postId;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BoardProvider boardProvider = context.watch<BoardProvider>();
    final AuthProvider authProvider = context.watch<AuthProvider>();
    final post = boardProvider.getPostById(widget.postId);

    if (post == null) {
      return const Scaffold(
        body: Center(child: Text('게시글을 찾을 수 없습니다.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
        actions: <Widget>[
          IconButton(
            tooltip: '수정',
            onPressed: () => context.pushNamed(
              AppRouteNames.postEditor,
              pathParameters: <String, String>{
                'categorySegment': post.category.pathSegment,
                'postId': post.id,
              },
            ),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('작성자: ${post.authorNickname} · 조회수 ${post.viewCount}'),
            const SizedBox(height: 12),
            Text('좋아요 ${post.likeCount} · 싫어요 ${post.dislikeCount}'),
            const SizedBox(height: 12),
            SelectableText(post.contentHtml),
            const SizedBox(height: 16),
            if (post.imageUrls.isNotEmpty)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: post.imageUrls
                    .map((url) => ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(url, width: 200, height: 150, fit: BoxFit.cover),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 24),
            Text('댓글 ${post.comments.length}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _buildCommentInput(authProvider, boardProvider, post.id),
            const SizedBox(height: 24),
            ...post.comments.map((comment) => _buildCommentTile(
                  context,
                  boardProvider,
                  post.id,
                  comment,
                  depth: 0,
                )),
          ],
        ),
      ),
    );
  }

  /// Builds the new comment input row.
  Widget _buildCommentInput(AuthProvider authProvider, BoardProvider provider, String postId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextField(
          controller: _commentController,
          minLines: 2,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: authProvider.isAuthenticated ? '댓글을 입력해 주세요' : '로그인 후 댓글을 작성할 수 있습니다',
            border: const OutlineInputBorder(),
          ),
          enabled: authProvider.isAuthenticated,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: authProvider.isAuthenticated
                ? () {
                    if (_commentController.text.isEmpty) {
                      return;
                    }
                    provider.addComment(
                      postId: postId,
                      comment: BoardComment(
                        id: 'comment-${DateTime.now().millisecondsSinceEpoch}',
                        postId: postId,
                        authorNickname: authProvider.currentUser!.nickname,
                        content: _commentController.text,
                        createdAt: DateTime.now(),
                      ),
                    );
                    _commentController.clear();
                  }
                : null,
            child: const Text('댓글 등록'),
          ),
        ),
      ],
    );
  }

  /// Recursively renders a comment and nested replies.
  Widget _buildCommentTile(
    BuildContext context,
    BoardProvider provider,
    String postId,
    BoardComment comment, {
    required int depth,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: depth * 24.0, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(comment.authorNickname, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: 8),
              Text(
                comment.createdAt.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment.content),
          TextButton.icon(
            onPressed: () => _openReplyDialog(context, provider, postId, comment.id),
            icon: const Icon(Icons.reply_outlined),
            label: const Text('답글 달기'),
          ),
          ...comment.replies.map(
            (reply) => _buildCommentTile(
              context,
              provider,
              postId,
              reply,
              depth: depth + 1,
            ),
          ),
        ],
      ),
    );
  }

  /// Opens a dialog to compose a nested reply.
  Future<void> _openReplyDialog(
    BuildContext context,
    BoardProvider provider,
    String postId,
    String parentId,
  ) async {
    final TextEditingController replyController = TextEditingController();
    final AuthProvider authProvider = context.read<AuthProvider>();
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('대댓글 작성'),
          content: TextField(
            controller: replyController,
            maxLines: 4,
            minLines: 2,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            enabled: authProvider.isAuthenticated,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: authProvider.isAuthenticated
                  ? () {
                      if (replyController.text.isEmpty) {
                        return;
                      }
                      provider.addComment(
                        postId: postId,
                        parentCommentId: parentId,
                        comment: BoardComment(
                          id: 'reply-${DateTime.now().millisecondsSinceEpoch}',
                          postId: postId,
                          authorNickname: authProvider.currentUser!.nickname,
                          content: replyController.text,
                          createdAt: DateTime.now(),
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  : null,
              child: const Text('등록'),
            ),
          ],
        );
      },
    );
  }
}
