// File: frontend/lib/models/board_comment.dart
// Description: Nested comment model supporting replies and reactions for posts.

/// Represents a single comment on a board post.
class BoardComment {
  /// Constructs a new comment instance.
  const BoardComment({
    required this.id,
    required this.postId,
    required this.authorNickname,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.replies = const <BoardComment>[],
  });

  /// Unique identifier of the comment.
  final String id;

  /// The parent post identifier.
  final String postId;

  /// Display nickname of the commenter.
  final String authorNickname;

  /// Comment content supporting HTML.
  final String content;

  /// Comment creation timestamp.
  final DateTime createdAt;

  /// Optional last edit timestamp.
  final DateTime? updatedAt;

  /// Nested replies enabling 대댓글 functionality.
  final List<BoardComment> replies;

  /// Creates a copy with modified replies.
  BoardComment copyWithReplies(List<BoardComment> nextReplies) => BoardComment(
        id: id,
        postId: postId,
        authorNickname: authorNickname,
        content: content,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
        replies: nextReplies,
      );
}
