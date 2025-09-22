# CosmosAI 멀티 게시판 서비스

플러터 3.29.3 버전을 기준으로 작성된 CosmosAI 커뮤니티 애플리케이션입니다. 웹과 모바일 모두에서 동작하도록 `go_router`, `provider`, `NavigationRail`, `NavigationBar` 등을 활용해 반응형 네비게이션을 구성했습니다. HTML 기반 글쓰기 에디터와 소셜 로그인 더미 흐름, 대댓글 지원 게시판, 딥링크 구조까지 포함하고 있습니다.

## 폴더 트리

```
cosmosai/
├── analysis_options.yaml
├── assets/
│   └── images/
├── backend/
│   └── .gitkeep
├── lib/
│   ├── app/
│   │   ├── app.dart
│   │   ├── router/
│   │   │   ├── app_route.dart
│   │   │   └── app_router.dart
│   │   └── widgets/
│   │       └── scaffold_with_nested_navigation.dart
│   ├── core/
│   │   ├── config/
│   │   │   └── app_config.dart
│   │   └── theme/
│   │       └── app_theme.dart
│   ├── data/
│   │   ├── datasources/
│   │   │   └── dummy_data_source.dart
│   │   └── repositories/
│   │       ├── auth_repository.dart
│   │       └── board_repository.dart
│   ├── features/
│   │   ├── auth/
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── auth_screen.dart
│   │   ├── board/
│   │   │   └── presentation/
│   │   │       ├── screens/
│   │   │       │   ├── board_gallery_screen.dart
│   │   │       │   ├── board_list_screen.dart
│   │   │       │   ├── post_detail_screen.dart
│   │   │       │   └── post_editor_screen.dart
│   │   │       └── widgets/
│   │   │           ├── comment_thread.dart
│   │   │           ├── post_card.dart
│   │   │           └── post_gallery_tile.dart
│   │   ├── common/
│   │   │   └── widgets/
│   │   │       ├── app_drawer.dart
│   │   │       └── app_top_bar.dart
│   │   ├── home/
│   │   │   └── presentation/
│   │   │       └── screens/
│   │   │           └── home_screen.dart
│   │   └── settings/
│   │       └── presentation/
│   │           └── screens/
│   │               └── settings_screen.dart
│   ├── models/
│   │   ├── board_category.dart
│   │   ├── comment_model.dart
│   │   ├── post_model.dart
│   │   └── user_model.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   └── view_count_provider.dart
│   └── main.dart
├── pubspec.yaml
└── README.md
```

## 주요 기능

- `go_router` 기반 상태 저장 네비게이션과 딥링크(`/post/:postId`, `/post-editor` 등) 구성
- `ScaffoldWithNavigationRail` / `ScaffoldWithNavigationBar`를 활용한 화면 크기 대응 네비게이션
- HTML 에디터(`html_editor_enhanced`)로 글 작성/수정 및 이미지 첨부 더미 동작
- `provider` 기반 전역 상태 관리, 더미 데이터(`DummyDataSource`) 로딩, 조회수 및 댓글 관리
- 로컬/카카오/구글/네이버 로그인 플로우에 맞춘 구조 (실제 키는 `lib/core/config/app_config.dart`에 “실제 사용키 삽입”으로 명시)
- 사용자 정보(웹3 지갑 비고 포함), 멀티 보드(뉴스/자유/기록/공지)와 대댓글 지원
- `backend/` 폴더는 향후 서버 모듈 확장을 위해 비워둔 상태입니다.

## 개발 참고

- Flutter 3.29.3 이상, Dart 3.5 이상 환경에서 사용하세요.
- `pubspec.yaml`에 정의된 패키지를 설치하려면 `flutter pub get`을 실행하세요.
- 웹에서 HTML 에디터를 사용할 때는 `html_editor_enhanced`의 WebView 지원을 위해 플랫폼 별 설정이 필요할 수 있습니다.
