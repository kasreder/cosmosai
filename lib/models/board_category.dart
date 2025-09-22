// File: lib/models/board_category.dart | Description: 게시판 카테고리를 정의하는 열거형.
import 'package:flutter/material.dart';

enum BoardCategory {
  home(
    key: 'home',
    title: '홈',
    description: '대시보드와 요약 정보를 제공',
    iconData: Icons.home_outlined,
  ),
  news(
    key: 'news',
    title: '뉴스',
    description: '최신 소식과 공지를 확인',
    iconData: Icons.campaign_outlined,
  ),
  free(
    key: 'free',
    title: '자유게시판',
    description: '사용자 간 자유로운 소통 공간',
    iconData: Icons.chat_bubble_outline,
  ),
  record(
    key: 'record',
    title: '기록/실험',
    description: '실험 기록과 포트폴리오 공유',
    iconData: Icons.science_outlined,
  ),
  notice(
    key: 'notice',
    title: '공지/제휴',
    description: '중요 공지와 제휴 안내',
    iconData: Icons.newspaper,
  ),
  settings(
    key: 'settings',
    title: '정보',
    description: '사용자 설정과 계정 관리',
    iconData: Icons.manage_accounts_outlined,
  );

  const BoardCategory({
    required this.key,
    required this.title,
    required this.description,
    required this.iconData,
  });

  final String key;
  final String title;
  final String description;
  final IconData iconData;

  static BoardCategory fromKey(String key) {
    return BoardCategory.values.firstWhere(
      (category) => category.key == key,
      orElse: () => BoardCategory.home,
    );
  }
}
