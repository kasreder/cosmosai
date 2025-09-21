// File: frontend/lib/models/board_category.dart
// Description: Category model describing the available multi-board channel options.

/// Supported categories for posts.
enum BoardCategory {
  /// 자유 게시판.
  free,

  /// 뉴스 게시판.
  news,

  /// 실험 게시판.
  experiment,

  /// 유저 정보 공유 게시판.
  userInfo,
}

/// Extension to provide localized labels and router paths.
extension BoardCategoryExtension on BoardCategory {
  /// Localized name displayed in UI.
  String get label {
    switch (this) {
      case BoardCategory.free:
        return '자유';
      case BoardCategory.news:
        return '뉴스';
      case BoardCategory.experiment:
        return '실험';
      case BoardCategory.userInfo:
        return '유저정보';
    }
  }

  /// Route friendly segment used in deep links.
  String get pathSegment {
    switch (this) {
      case BoardCategory.free:
        return 'free';
      case BoardCategory.news:
        return 'news';
      case BoardCategory.experiment:
        return 'experiment';
      case BoardCategory.userInfo:
        return 'user-info';
    }
  }

  /// Utility to parse a segment into [BoardCategory].
  static BoardCategory fromSegment(String segment) {
    return BoardCategory.values.firstWhere(
      (value) => value.pathSegment == segment,
      orElse: () => BoardCategory.free,
    );
  }
}
