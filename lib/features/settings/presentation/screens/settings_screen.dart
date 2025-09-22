// File: lib/features/settings/presentation/screens/settings_screen.dart | Description: 사용자 정보 및 Web3 지갑 메모를 관리하는 화면.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../models/user_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../common/widgets/app_drawer.dart';
import '../../../common/widgets/app_top_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.watch<AuthProvider>();
    final UserModel? user = authProvider.currentUser;

    return Scaffold(
      appBar: const AppTopBar(title: '사용자 설정'),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: user == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('로그인이 필요합니다.', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  const Text('로컬 또는 소셜 로그인을 진행해 주세요.'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => context.push('/auth'),
                    icon: const Icon(Icons.login),
                    label: const Text('로그인하러 가기'),
                  ),
                ],
              )
            : ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('이름'),
                    subtitle: Text(user.name),
                  ),
                  ListTile(
                    leading: const Icon(Icons.alternate_email),
                    title: const Text('이메일 (ID)'),
                    subtitle: Text(user.email),
                  ),
                  ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: const Text('닉네임'),
                    subtitle: Text(user.nickname),
                  ),
                  ListTile(
                    leading: const Icon(Icons.shield_outlined),
                    title: const Text('로그인 유형'),
                    subtitle: Text(user.loginType.name),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: const Text('가입일'),
                    subtitle: Text(user.createdAt.toIso8601String()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.update),
                    title: const Text('정보 수정일'),
                    subtitle: Text(user.updatedAt.toIso8601String()),
                  ),
                  ListTile(
                    leading: const Icon(Icons.monetization_on_outlined),
                    title: const Text('포인트'),
                    subtitle: Text('${user.point} P'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.wallet),
                    title: const Text('비고1 (Web3 지갑)'),
                    subtitle: Text(user.memo1 ?? '미등록'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.wallet_giftcard),
                    title: const Text('비고2 (Web3 지갑)'),
                    subtitle: Text(user.memo2 ?? '미등록'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.wallet_membership),
                    title: const Text('비고3 (Web3 지갑)'),
                    subtitle: Text(user.memo3 ?? '미등록'),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: authProvider.signOut,
                    icon: const Icon(Icons.logout),
                    label: const Text('로그아웃'),
                  ),
                ],
              ),
      ),
    );
  }
}
