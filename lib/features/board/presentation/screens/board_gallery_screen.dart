// File: lib/features/board/presentation/screens/board_gallery_screen.dart | Description: 액자형 게시판 화면 구성.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_route.dart';
import '../../../../models/board_category.dart';
import '../../../../models/post_model.dart';
import '../../../../providers/view_count_provider.dart';
import '../../../common/widgets/app_drawer.dart';
import '../../../common/widgets/app_top_bar.dart';
import '../widgets/post_gallery_tile.dart';

class BoardGalleryScreen extends StatelessWidget {
  const BoardGalleryScreen({super.key, required this.category});

  final BoardCategory category;

  @override
  Widget build(BuildContext context) {
    final ViewCountProvider viewCountProvider = context.watch<ViewCountProvider>();
    final List<PostModel> posts = viewCountProvider.getPosts(category);
    final int crossAxisCount = MediaQuery.of(context).size.width > 1000
        ? 4
        : MediaQuery.of(context).size.width > 700
            ? 3
            : 2;

    return Scaffold(
      appBar: AppTopBar(title: '${category.title} (갤러리)'),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_photo_alternate_outlined),
        label: const Text('새 기록 작성'),
        onPressed: () => context.pushNamed(AppRoute.postEditor.name, extra: category),
      ),
      body: RefreshIndicator(
        onRefresh: () => viewCountProvider.fetchPostDataFromAPI(category.key),
        child: posts.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const <Widget>[
                  SizedBox(height: 120),
                  Center(child: Text('아직 업로드된 기록이 없습니다. 사진과 함께 공유해 보세요!')),
                ],
              )
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: posts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (BuildContext context, int index) {
                  final PostModel post = posts[index];
                  return PostGalleryTile(
                    post: post,
                    onTap: () => context.pushNamed(
                      AppRoute.postDetail.name,
                      pathParameters: <String, String>{'postId': post.id},
                      extra: post,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
