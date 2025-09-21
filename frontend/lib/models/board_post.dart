// File: frontend/lib/models/board_post.dart
// Description: Board post model containing metadata, reaction counts, and nested comments.

import 'board_category.dart';
import 'board_comment.dart';

/// Represents a single board post with optional gallery assets.
class BoardPost {
  /// Creates a new post.
  const BoardPost({
    required this.id,
    required this.title,
    required this.authorNickname,
    required this.viewCount,
    required this.contentHtml,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.imageUrls = const <String>[],
    this.comments = const <BoardComment>[],
  });

  /// Unique identifier for the post.
  final String id;

  /// Title of the post.
  final String title;

  /// Nickname of the author.
  final String authorNickname;

  /// View counter.
  final int viewCount;

  /// HTML content of the post.
  final String contentHtml;

  /// Category of the board.
  final BoardCategory category;

  /// Like counter.
  final int likeCount;

  /// Dislike counter.
  final int dislikeCount;

  /// Creation time.
  final DateTime createdAt;

  /// Last update time.
  final DateTime updatedAt;

  /// Optional gallery image urls.
  final List<String> imageUrls;

  /// Comments with nested replies.
  final List<BoardComment> comments;

  /// Creates a modified copy of the post.
  BoardPost copyWith({
    String? title,
    String? contentHtml,
    int? viewCount,
    int? likeCount,
    int? dislikeCount,
    List<String>? imageUrls,
    List<BoardComment>? comments,
  }) {
    return BoardPost(
      id: id,
      title: title ?? this.title,
      authorNickname: authorNickname,
      viewCount: viewCount ?? this.viewCount,
      contentHtml: contentHtml ?? this.contentHtml,
      category: category,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      likeCount: likeCount ?? this.likeCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      imageUrls: imageUrls ?? this.imageUrls,
      comments: comments ?? this.comments,
    );
  }
}
