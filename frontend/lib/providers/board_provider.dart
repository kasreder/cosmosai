// File: frontend/lib/providers/board_provider.dart
// Description: Provider managing board filtering, post selection, and CRUD stubs using dummy data.

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../data/dummy_data.dart';
import '../models/board_category.dart';
import '../models/board_comment.dart';
import '../models/board_post.dart';

/// Provider to expose board information and editing helpers.
class BoardProvider extends ChangeNotifier {
  /// Internal database reference for dummy operations.
  final DummyDatabase _database = DummyDatabase.instance;

  /// Currently selected category.
  BoardCategory _selectedCategory = BoardCategory.free;

  /// Readonly stream of posts.
  List<BoardPost> _posts = <BoardPost>[];

  /// Creates the provider by loading initial dummy data.
  BoardProvider() {
    _posts = _database.posts;
  }

  /// Exposes the active category.
  BoardCategory get selectedCategory => _selectedCategory;

  /// Returns the filtered posts for the active category.
  List<BoardPost> get filteredPosts => _posts
      .where((post) => post.category == _selectedCategory)
      .sorted((a, b) => b.createdAt.compareTo(a.createdAt));

  /// Returns the posts that contain gallery images.
  List<BoardPost> get galleryPosts => _posts
      .where((post) => post.imageUrls.isNotEmpty)
      .sorted((a, b) => b.createdAt.compareTo(a.createdAt));

  /// Retrieves a single post by identifier.
  BoardPost? getPostById(String id) =>
      _posts.firstWhereOrNull((post) => post.id == id);

  /// Selects a new category and notifies listeners.
  void updateCategory(BoardCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Adds a new post using dummy data store semantics.
  void createPost(BoardPost post) {
    _posts = <BoardPost>[post, ..._posts];
    notifyListeners();
  }

  /// Updates an existing post.
  void updatePost(BoardPost updated) {
    _posts = _posts
        .map((post) => post.id == updated.id ? updated : post)
        .toList(growable: false);
    notifyListeners();
  }

  /// Adds a comment or reply to a post to demonstrate 대댓글.
  void addComment({
    required String postId,
    required BoardComment comment,
    String? parentCommentId,
  }) {
    final BoardPost? post = getPostById(postId);
    if (post == null) {
      return;
    }
    if (parentCommentId == null) {
      final BoardPost updated = post.copyWith(
        comments: <BoardComment>[comment, ...post.comments],
      );
      updatePost(updated);
      return;
    }
    final List<BoardComment> updatedComments = post.comments
        .map((existing) {
          if (existing.id == parentCommentId) {
            return existing.copyWithReplies(<BoardComment>[comment, ...existing.replies]);
          }
          return existing;
        })
        .toList(growable: false);
    updatePost(post.copyWith(comments: updatedComments));
  }
}
