// File: lib/features/home/presentation/screens/home_screen.dart | Description: 대시보드 형태의 홈 화면.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_route.dart';
import '../../../../models/board_category.dart';
import '../../../../models/post_model.dart';
import '../../../../providers/view_count_provider.dart';
import '../../../common/widgets/app_drawer.dart';
import '../../../common/widgets/app_top_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ViewCountProvider provider = context.watch<ViewCountProvider>();

    final List<PostModel> news = provider.getPosts(BoardCategory.news);
    final List<PostModel> free = provider.getPosts(BoardCategory.free);
    final List<PostModel> record = provider.getPosts(BoardCategory.record);
    final bool isLoading = provider.isLoading;

    return Scaffold(
      appBar: const AppTopBar(title: 'CosmosAI 커뮤니티 홈'),
      drawer: const AppDrawer(),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isWide = constraints.maxWidth > 900;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (isLoading)
                  const LinearProgressIndicator(),
                if (isLoading) const SizedBox(height: 12),
                Text('오늘의 하이라이트', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: BoardCategory.values
                      .where((BoardCategory category) => category != BoardCategory.home)
                      .map((BoardCategory category) {
                    final IconData icon = category.iconData;
                    return _CategoryCard(
                      title: category.title,
                      description: category.description,
                      iconData: icon,
                      onTap: () {
                        context.go(category == BoardCategory.settings ? AppRoute.settings.path : '/${category.key}');
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                if (news.isNotEmpty)
                  _buildSection(
                    context,
                    title: '뉴스 최신글',
                    posts: news,
                    isWide: isWide,
                    onTapMore: () => context.go(AppRoute.news.path),
                  ),
                if (free.isNotEmpty)
                  _buildSection(
                    context,
                    title: '자유게시판 인기글',
                    posts: free,
                    isWide: isWide,
                    onTapMore: () => context.go(AppRoute.free.path),
                  ),
                if (record.isNotEmpty)
                  _buildSection(
                    context,
                    title: '기록/실험 미리보기',
                    posts: record,
                    isWide: isWide,
                    onTapMore: () => context.go(AppRoute.record.path),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<PostModel> posts,
    required bool isWide,
    required VoidCallback onTapMore,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            TextButton(onPressed: onTapMore, child: const Text('더보기')),
          ],
        ),
        SizedBox(
          height: isWide ? 200 : 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: posts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (BuildContext context, int index) {
              final PostModel post = posts[index];
              return SizedBox(
                width: isWide ? 320 : 260,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(post.title, style: Theme.of(context).textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 12),
                        Text(post.authorNickname, style: Theme.of(context).textTheme.bodySmall),
                        const Spacer(),
                        FilledButton.tonal(
                          onPressed: () => context.pushNamed(
                            AppRoute.postDetail.name,
                            pathParameters: <String, String>{'postId': post.id},
                            extra: post,
                          ),
                          child: const Text('바로가기'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.description,
    required this.iconData,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(iconData, size: 32),
                const SizedBox(height: 12),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
