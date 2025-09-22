// File: lib/features/board/presentation/screens/post_detail_screen.dart | Description: 게시글 본문과 댓글, 대댓글을 보여주는 화면.
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

import '../../../../models/comment_model.dart';
import '../../../../models/post_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/view_count_provider.dart';
import '../../../common/widgets/app_drawer.dart';
import '../../../common/widgets/app_top_bar.dart';
import '../widgets/comment_thread.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({
    super.key,
    required this.postId,
    this.initialPost,
  });

  final String postId;
  final PostModel? initialPost;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  CommentModel? _replyTarget;
  PostModel? _post;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadPost());
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadPost() async {
    final ViewCountProvider viewProvider = context.read<ViewCountProvider>();
    PostModel? post = widget.initialPost;
    post ??= await viewProvider.resolvePostById(widget.postId);
    if (post != null) {
      viewProvider.incrementView(post.id);
    }
    setState(() {
      _post = post;
      _isLoading = false;
    });
  }

  Future<void> _submitComment() async {
    if (_post == null) {
      return;
    }
    final String content = _commentController.text.trim();
    if (content.isEmpty) {
      return;
    }
    final AuthProvider authProvider = context.read<AuthProvider>();
    final String nickname = authProvider.currentUser?.nickname ?? '익명 탐험가';

    final CommentModel newComment = CommentModel(
      postId: _post!.id,
      authorNickname: nickname,
      content: content,
      parentId: _replyTarget?.id,
    );

    List<CommentModel> updatedComments = _post!.comments.map((CommentModel comment) => _cloneComment(comment)).toList();
    if (_replyTarget == null) {
      updatedComments.add(newComment);
    } else {
      updatedComments = _insertReply(updatedComments, _replyTarget!, newComment);
    }

    final PostModel updatedPost = _post!.copyWith(comments: updatedComments);
    await context.read<ViewCountProvider>().savePost(updatedPost);

    setState(() {
      _post = updatedPost;
      _commentController.clear();
      _replyTarget = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('댓글이 등록되었습니다.')),
    );
  }

  CommentModel _cloneComment(CommentModel comment) {
    return comment.copyWith(
      replies: comment.replies.map(_cloneComment).toList(),
    );
  }

  List<CommentModel> _insertReply(
    List<CommentModel> comments,
    CommentModel target,
    CommentModel reply,
  ) {
    return comments.map((CommentModel comment) {
      if (comment.id == target.id) {
        final List<CommentModel> replies = <CommentModel>[...comment.replies, reply];
        return comment.copyWith(replies: replies);
      }
      if (comment.replies.isNotEmpty) {
        return comment.copyWith(
          replies: _insertReply(comment.replies.map(_cloneComment).toList(), target, reply),
        );
      }
      return comment;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_post == null) {
      return const Scaffold(
        body: Center(child: Text('게시글을 찾을 수 없습니다.')), // ❗ 딥링크로 진입했으나 데이터가 없는 경우 처리
      );
    }

    final int viewCount = context.watch<ViewCountProvider>().getViewCount(_post!.id);

    return Scaffold(
      appBar: AppTopBar(title: _post!.title),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_post!.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Text('작성자: ${_post!.authorNickname}'),
                  const SizedBox(width: 12),
                  Text('조회수: $viewCount'),
                  const SizedBox(width: 12),
                  Text('좋아요: ${_post!.likeCount}'),
                  const SizedBox(width: 12),
                  Text('싫어요: ${_post!.dislikeCount}'),
                ],
              ),
              const Divider(height: 32),
              HtmlWidget(
                _post!.content,
                textStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              if (_post!.imageUrls.isNotEmpty) ..._post!.imageUrls.map((String url) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Image.asset(url, fit: BoxFit.cover),
                );
              }),
              const Divider(height: 32),
              Text('댓글 ${_post!.comments.length}', style: Theme.of(context).textTheme.titleMedium),
              CommentThread(
                comments: _post!.comments,
                onReply: (CommentModel comment) {
                  setState(() {
                    _replyTarget = comment;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('대댓글 작성 대상: ${comment.authorNickname}')),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _commentController,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: _replyTarget == null ? '댓글을 입력하세요.' : '대댓글 입력 (${_replyTarget!.authorNickname}님에게)',
                  border: const OutlineInputBorder(),
                  suffixIcon: _replyTarget == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _replyTarget = null),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: _submitComment,
                  icon: const Icon(Icons.send),
                  label: const Text('등록'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
