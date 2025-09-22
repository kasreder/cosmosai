// File: lib/data/repositories/board_repository.dart | Description: 게시판 관련 데이터 접근 레이어.
import 'package:collection/collection.dart';

import '../../models/board_category.dart';
import '../../models/post_model.dart';
import '../datasources/dummy_data_source.dart';

class BoardRepository {
  BoardRepository(this._dataSource);

  final DummyDataSource _dataSource;

  Future<List<PostModel>> fetchPosts(BoardCategory category) async {
    // 📥 실제 구현에서는 API 호출 또는 데이터베이스 연동 예정
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _dataSource.posts
        .where((post) => post.category == category)
        .toList();
  }

  Future<PostModel?> findPostById(String postId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _dataSource.posts.firstWhereOrNull((post) => post.id == postId);
  }

  Future<PostModel> savePost(PostModel post) async {
    // 💾 더미 환경에서는 리스트를 갱신하는 형태로 처리
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _dataSource.upsertPost(post);
    return post;
  }
}
