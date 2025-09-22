// File: lib/features/common/widgets/app_drawer.dart | Description: 앱 전역에서 재사용할 사이드 Drawer 위젯.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_route.dart';
import '../../../models/board_category.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Color(0xFF4A6CF7), Color(0xFF6C8CFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'CosmosAI Navigator',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ...BoardCategory.values
                .where((BoardCategory category) => category != BoardCategory.home)
                .map((BoardCategory category) {
              final String path = _pathForCategory(category);
              return ListTile(
                leading: Icon(category.iconData),
                title: Text(category.title),
                subtitle: Text(category.description),
                onTap: () => context.go(path),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _pathForCategory(BoardCategory category) {
    switch (category) {
      case BoardCategory.news:
        return AppRoute.news.path;
      case BoardCategory.free:
        return AppRoute.free.path;
      case BoardCategory.record:
        return AppRoute.record.path;
      case BoardCategory.notice:
        return AppRoute.notice.path;
      case BoardCategory.settings:
        return AppRoute.settings.path;
      case BoardCategory.home:
        return AppRoute.home.path;
    }
  }
}
