// File: frontend/lib/data/dummy_data.dart
// Description: In-memory dummy data simulating backend responses for development and testing.

import 'package:collection/collection.dart';

import '../models/board_category.dart';
import '../models/board_comment.dart';
import '../models/board_post.dart';
import '../models/login_method.dart';
import '../models/user_profile.dart';

/// Provides fake backend data to unblock UI development.
class DummyDatabase {
  /// Singleton instance for easy reuse across providers.
  DummyDatabase._();

  /// Global instance accessor.
  static final DummyDatabase instance = DummyDatabase._();

  /// Cached user list.
  final List<UserProfile> _users = <UserProfile>[
    UserProfile(
      id: 'alice@example.com',
      name: 'Alice Kim',
      email: 'alice@example.com',
      nickname: '별빛',
      loginMethod: LoginMethod.local,
      point: 1200,
      createdAt: DateTime(2024, 1, 3),
      updatedAt: DateTime(2024, 9, 12),
      localPassword: 'hashed-password-placeholder',
      memo1: '0x1234...abcd',
    ),
    UserProfile(
      id: 'bob@kakao.com',
      name: 'Bob Park',
      email: 'bob@kakao.com',
      nickname: '초코송이',
      loginMethod: LoginMethod.kakao,
      point: 980,
      createdAt: DateTime(2024, 2, 14),
      updatedAt: DateTime(2024, 9, 14),
    ),
    UserProfile(
      id: 'carol@google.com',
      name: 'Carol Choi',
      email: 'carol@google.com',
      nickname: '실험요정',
      loginMethod: LoginMethod.google,
      point: 1520,
      createdAt: DateTime(2024, 3, 2),
      updatedAt: DateTime(2024, 9, 10),
      memo2: '0x9876...1122',
    ),
  ];

  /// Cached posts with nested comments.
  final List<BoardPost> _posts = <BoardPost>[
    BoardPost(
      id: 'post-1',
      title: '커뮤니티 이용 안내',
      authorNickname: '별빛',
      viewCount: 312,
      contentHtml:
          '<h2>환영합니다</h2><p>자유롭게 의견을 남기고 이미지도 공유해 주세요.</p>',
      category: BoardCategory.free,
      createdAt: DateTime(2024, 8, 1, 10, 30),
      updatedAt: DateTime(2024, 8, 1, 10, 30),
      likeCount: 12,
      dislikeCount: 0,
      imageUrls: <String>[
        'https://picsum.photos/id/1015/600/400',
        'https://picsum.photos/id/1016/600/400',
      ],
      comments: <BoardComment>[
        BoardComment(
          id: 'comment-1',
          postId: 'post-1',
          authorNickname: '초코송이',
          content: '<p>환영합니다! 규칙도 꼭 지켜요 :)</p>',
          createdAt: DateTime(2024, 8, 1, 12, 0),
          replies: <BoardComment>[
            BoardComment(
              id: 'comment-1-1',
              postId: 'post-1',
              authorNickname: '별빛',
              content: '<p>좋은 말씀 감사해요!</p>',
              createdAt: DateTime(2024, 8, 1, 12, 45),
            ),
          ],
        ),
      ],
    ),
    BoardPost(
      id: 'post-2',
      title: '최신 Web3 뉴스 공유',
      authorNickname: '실험요정',
      viewCount: 412,
      contentHtml:
          '<p>이번 주에는 <strong>탈중앙화 지갑</strong> 관련 업데이트가 있었습니다.</p>',
      category: BoardCategory.news,
      createdAt: DateTime(2024, 8, 12, 9, 15),
      updatedAt: DateTime(2024, 8, 13, 11, 0),
      likeCount: 28,
      dislikeCount: 4,
    ),
    BoardPost(
      id: 'post-3',
      title: '실험실 장비 공유 스냅샷',
      authorNickname: '초코송이',
      viewCount: 128,
      contentHtml:
          '<p>실험 장비 배치를 사진으로 공유합니다. 의견 주세요!</p>',
      category: BoardCategory.experiment,
      createdAt: DateTime(2024, 8, 20, 14, 0),
      updatedAt: DateTime(2024, 8, 20, 14, 0),
      imageUrls: <String>[
        'https://picsum.photos/id/1018/600/400',
        'https://picsum.photos/id/1020/600/400',
      ],
    ),
  ];

  /// Exposes an immutable copy of the users.
  List<UserProfile> get users => List<UserProfile>.unmodifiable(_users);

  /// Exposes an immutable copy of posts sorted by date.
  List<BoardPost> get posts => _posts.sorted((a, b) => b.createdAt.compareTo(a.createdAt));
}
