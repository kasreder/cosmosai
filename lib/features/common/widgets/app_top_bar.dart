// File: lib/features/common/widgets/app_top_bar.dart | Description: Drawer, 딥링크, 로그인 액션을 포함한 공통 AppBar.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.watch<AuthProvider>();
    final bool isLoggedIn = authProvider.currentUser != null;

    return AppBar(
      title: Text(title),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
      actions: <Widget>[
        if (actions != null) ...actions!,
        IconButton(
          tooltip: '딥링크 공유',
          icon: const Icon(Icons.link),
          onPressed: () {
            final String location = GoRouter.of(context).location;
            final Uri uri = Uri.parse('https://cosmosai.dev$location');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('딥링크가 복사되었습니다: $uri')),
            );
          },
        ),
        if (!isLoggedIn)
          IconButton(
            tooltip: '로그인',
            icon: const Icon(Icons.login),
            onPressed: () => context.push('/auth'),
          )
        else
          IconButton(
            tooltip: '로그아웃',
            icon: const Icon(Icons.logout),
            onPressed: authProvider.signOut,
          ),
      ],
    );
  }
}
