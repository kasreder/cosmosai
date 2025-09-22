// File: lib/app/router/app_route.dart | Description: 고루터 라우트 이름과 경로 상수 정의.
enum AppRoute {
  home('/home'),
  news('/news'),
  free('/free'),
  record('/record'),
  notice('/notice'),
  settings('/settings'),
  postDetail('/post/:postId'),
  postEditor('/post-editor');

  const AppRoute(this.path);

  final String path;

  String get name => toString().split('.').last;
}
