// File: lib/app/widgets/scaffold_with_nested_navigation.dart | Description: 반응형 네비게이션 레이아웃 및 Drawer, NavigationRail 구성.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

import '../../models/board_category.dart';
import '../../providers/view_count_provider.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index, BuildContext context) {
    // 🚀 네비게이션 이동 처리 및 게시판 데이터 새로고침
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        return;
      }
      final ViewCountProvider boardProvider = Provider.of<ViewCountProvider>(context, listen: false);
      switch (index) {
        case 0:
          boardProvider.prefetchForHome();
          break;
        case 1:
          boardProvider.fetchPostDataFromAPI(BoardCategory.news.key);
          break;
        case 2:
          boardProvider.fetchPostDataFromAPI(BoardCategory.free.key);
          break;
        case 3:
          boardProvider.fetchPostDataFromAPI(BoardCategory.record.key);
          break;
        case 4:
          boardProvider.fetchPostDataFromAPI(BoardCategory.notice.key);
          break;
        case 5:
          // ⚙️ 설정 화면은 데이터 로딩이 필요 없음
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 450) {
          return ScaffoldWithNavigationBar(
            body: navigationShell,
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (int index) => _goBranch(index, context),
          );
        } else {
          return FutureBuilder<void>(
            future: Future<void>.delayed(const Duration(milliseconds: 100)),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return ScaffoldWithNavigationRail(
                body: navigationShell,
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (int index) => _goBranch(index, context),
              );
            },
          );
        }
      },
    );
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: selectedIndex,
        destinations: const <NavigationDestination>[
          NavigationDestination(label: '홈', icon: Icon(UniconsLine.home)),
          NavigationDestination(label: '뉴스', icon: Icon(UniconsLine.megaphone)),
          NavigationDestination(label: '자유게시판', icon: Icon(UniconsLine.comment_alt_dots)),
          NavigationDestination(label: '기록/실험', icon: Icon(UniconsLine.flask)),
          NavigationDestination(label: '공지/제휴', icon: Icon(UniconsLine.newspaper)),
          NavigationDestination(label: '설정', icon: Icon(UniconsLine.user_circle)),
        ],
        onDestinationSelected: onDestinationSelected,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      ),
    );
  }
}

class ScaffoldWithNavigationRail extends StatelessWidget {
  const ScaffoldWithNavigationRail({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.none,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(label: Text('Home'), icon: Icon(UniconsLine.home)),
              NavigationRailDestination(label: Text('News'), icon: Icon(UniconsLine.megaphone)),
              NavigationRailDestination(label: Text('Free'), icon: Icon(UniconsLine.comment_alt_dots)),
              NavigationRailDestination(label: Text('Record'), icon: Icon(UniconsLine.flask)),
              NavigationRailDestination(label: Text('Notice'), icon: Icon(UniconsLine.newspaper)),
              NavigationRailDestination(label: Text('Info'), icon: Icon(UniconsLine.user_circle)),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}
