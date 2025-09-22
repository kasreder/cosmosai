// File: lib/data/datasources/dummy_data_source.dart | Description: 초기 개발을 위한 더미 데이터 소스.
import 'package:intl/intl.dart';

import '../../models/board_category.dart';
import '../../models/comment_model.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';

class DummyDataSource {
  DummyDataSource() {
    _seedData();
  }

  final List<UserModel> _users = <UserModel>[];
  final List<PostModel> _posts = <PostModel>[];

  List<UserModel> get users => List<UserModel>.unmodifiable(_users);
  List<PostModel> get posts => List<PostModel>.unmodifiable(_posts);

  void upsertPost(PostModel post) {
    final int index = _posts.indexWhere((PostModel element) => element.id == post.id);
    if (index == -1) {
      _posts.insert(0, post);
    } else {
      _posts[index] = post;
    }
  }

  void _seedData() {
    // 📦 초기 데이터 생성
    final UserModel localUser = UserModel(
      name: 'Cosmos Local',
      email: 'local@cosmos.ai',
      nickname: '코스모스',
      loginType: LoginType.local,
    );
    final UserModel kakaoUser = UserModel(
      name: 'Kakao User',
      email: 'kakao@cosmos.ai',
      nickname: '카카오인',
      loginType: LoginType.kakao,
    );
    _users.addAll(<UserModel>[localUser, kakaoUser]);

    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    final List<PostModel> seededPosts = <PostModel>[
      PostModel(
        title: '환영합니다! CosmosAI 커뮤니티 시작',
        authorNickname: localUser.nickname,
        category: BoardCategory.notice,
        content:
            '<h2>커뮤니티 오픈</h2><p>CosmosAI 커뮤니티에 오신 것을 환영합니다. 앞으로 다양한 소식을 공유해요.</p>',
        likeCount: 12,
        dislikeCount: 1,
        viewCount: 128,
        createdAt: formatter.parse('2024-01-15 10:00'),
        imageUrls: const <String>[],
      ),
      PostModel(
        title: 'AI 뉴스 브리핑 - 2024년 2월',
        authorNickname: kakaoUser.nickname,
        category: BoardCategory.news,
        content:
            '<p>오늘의 AI 뉴스는 <strong>멀티모달 모델</strong> 개발 소식입니다. 새로운 도약을 함께 지켜봐요.</p>',
        likeCount: 54,
        dislikeCount: 2,
        viewCount: 302,
        createdAt: formatter.parse('2024-02-02 09:30'),
        imageUrls: const <String>['assets/images/news_cover.png'],
      ),
      PostModel(
        title: 'Flutter 레이아웃 꿀팁 공유',
        authorNickname: localUser.nickname,
        category: BoardCategory.free,
        content:
            '<p>반응형 UI를 만들 때 <em>LayoutBuilder</em>와 <em>MediaQuery</em>를 적절히 활용해 보세요!</p>',
        likeCount: 24,
        dislikeCount: 0,
        viewCount: 98,
        createdAt: formatter.parse('2024-03-21 14:20'),
      ),
      PostModel(
        title: 'Vision Agent 실험 로그 #1',
        authorNickname: '실험가',
        category: BoardCategory.record,
        content:
            '<p>이번 실험에서는 이미지 분석 파이프라인을 구축했습니다. 스크린샷과 결과를 확인하세요.</p>',
        likeCount: 73,
        dislikeCount: 3,
        viewCount: 512,
        createdAt: formatter.parse('2024-04-04 20:40'),
        imageUrls: const <String>[
          'assets/images/lab_1.png',
          'assets/images/lab_2.png',
        ],
      ),
    ];

    final CommentModel rootComment = CommentModel(
      postId: seededPosts.first.id,
      authorNickname: '참여자',
      content: '환영합니다! 앞으로 기대할게요.',
    );
    final CommentModel replyComment = CommentModel(
      postId: seededPosts.first.id,
      authorNickname: '코스모스',
      content: '응원의 말씀 감사합니다 😊',
      parentId: rootComment.id,
    );

    _posts
      ..addAll(seededPosts)
      ..firstWhere((post) => post.id == seededPosts.first.id)
          .comments
          .addAll(<CommentModel>[rootComment, replyComment]);
  }
}
