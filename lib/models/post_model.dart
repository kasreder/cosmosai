// File: lib/models/post_model.dart | Description: 게시글, 좋아요, 조회수 정보를 포함한 모델.
import 'package:uuid/uuid.dart';

import 'board_category.dart';
import 'comment_model.dart';

class PostModel {
  PostModel({
    String? id,
    required this.title,
    required this.authorNickname,
    required this.category,
    required this.content,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.viewCount = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? imageUrls,
    List<CommentModel>? comments,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        imageUrls = imageUrls ?? <String>[],
        comments = comments ?? <CommentModel>[];

  final String id;
  final String title;
  final String authorNickname;
  final BoardCategory category;
  final String content;
  final int likeCount;
  final int dislikeCount;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> imageUrls;
  final List<CommentModel> comments;

  PostModel copyWith({
    String? title,
    String? content,
    int? likeCount,
    int? dislikeCount,
    int? viewCount,
    DateTime? updatedAt,
    List<String>? imageUrls,
    List<CommentModel>? comments,
  }) {
    // 🔁 게시글 내용/통계를 수정할 때 사용
    return PostModel(
      id: id,
      title: title ?? this.title,
      authorNickname: authorNickname,
      category: category,
      content: content ?? this.content,
      likeCount: likeCount ?? this.likeCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      imageUrls: imageUrls ?? this.imageUrls,
      comments: comments ?? this.comments,
    );
  }
}
