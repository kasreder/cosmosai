// File: lib/providers/view_count_provider.dart | Description: 게시글 조회수 및 데이터 캐싱을 담당하는 Provider.
import 'package:flutter/material.dart';

import '../data/repositories/board_repository.dart';
import '../models/board_category.dart';
import '../models/post_model.dart';

class ViewCountProvider extends ChangeNotifier {
  ViewCountProvider(this._repository);

  final BoardRepository _repository;
  final Map<BoardCategory, List<PostModel>> _categoryPosts = <BoardCategory, List<PostModel>>{};

  final Map<String, int> _viewCounts = <String, int>{};
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<PostModel> getPosts(BoardCategory category) {
    // 📚 로컬 캐시에 저장된 게시글 반환
    return _categoryPosts[category] ?? <PostModel>[];
  }

  int getViewCount(String postId) {
    return _viewCounts[postId] ?? 0;
  }

  Future<PostModel?> resolvePostById(String postId) async {
    // 🔎 캐시에서 게시글을 찾고 없으면 저장소에서 로드
    for (final List<PostModel> posts in _categoryPosts.values) {
      try {
        return posts.firstWhere((PostModel element) => element.id == postId);
      } catch (_) {
        continue;
      }
    }
    final PostModel? fetched = await _repository.findPostById(postId);
    if (fetched != null) {
      _cachePost(fetched);
    }
    return fetched;
  }

  Future<void> fetchPostDataFromAPI(String categoryKey) async {
    // 🌐 네비게이션 이동 시 게시판 데이터를 새로 고침
    final BoardCategory category = BoardCategory.fromKey(categoryKey);
    _isLoading = true;
    notifyListeners();

    final List<PostModel> posts = await _repository.fetchPosts(category);
    _categoryPosts[category] = posts;

    for (final PostModel post in posts) {
      _viewCounts[post.id] = post.viewCount;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> prefetchForHome() async {
    _isLoading = true;
    notifyListeners();
    for (final BoardCategory category in <BoardCategory>[
      BoardCategory.news,
      BoardCategory.free,
      BoardCategory.record,
      BoardCategory.notice,
    ]) {
      final List<PostModel> posts = await _repository.fetchPosts(category);
      _categoryPosts[category] = posts;
      for (final PostModel post in posts) {
        _viewCounts[post.id] = post.viewCount;
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  void incrementView(String postId) {
    // 👁️ 게시글 상세 페이지 진입 시 조회수 증가
    _viewCounts.update(postId, (value) => value + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  Future<void> savePost(PostModel post) async {
    await _repository.savePost(post);
    _cachePost(post);
  }

  void cachePost(PostModel post) {
    _cachePost(post);
  }

  void _cachePost(PostModel post) {
    // ✏️ 글 작성/수정 후 데이터를 최신 상태로 유지
    final List<PostModel> posts = _categoryPosts[post.category] ?? <PostModel>[];
    final int index = posts.indexWhere((element) => element.id == post.id);
    if (index == -1) {
      posts.insert(0, post);
    } else {
      posts[index] = post;
    }
    _categoryPosts[post.category] = posts;
    _viewCounts[post.id] = post.viewCount;
    notifyListeners();
  }
}
