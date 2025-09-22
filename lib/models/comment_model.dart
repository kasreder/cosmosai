// File: lib/models/comment_model.dart | Description: 댓글 및 대댓글 구조 모델 정의.
import 'package:uuid/uuid.dart';

class CommentModel {
  CommentModel({
    String? id,
    required this.postId,
    required this.authorNickname,
    required this.content,
    this.parentId,
    DateTime? createdAt,
    List<CommentModel>? replies,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        replies = replies ?? <CommentModel>[];

  final String id;
  final String postId;
  final String authorNickname;
  final String content;
  final String? parentId;
  final DateTime createdAt;
  final List<CommentModel> replies;

  CommentModel copyWith({
    String? content,
    List<CommentModel>? replies,
  }) {
    // 📝 댓글 내용을 수정하거나 대댓글을 추가할 때 사용
    return CommentModel(
      id: id,
      postId: postId,
      authorNickname: authorNickname,
      content: content ?? this.content,
      parentId: parentId,
      createdAt: createdAt,
      replies: replies ?? this.replies,
    );
  }
}
