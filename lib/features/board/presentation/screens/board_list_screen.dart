// File: lib/features/board/presentation/screens/board_list_screen.dart | Description: 리스트형 게시판 화면 구성.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_route.dart';
import '../../../../models/board_category.dart';
import '../../../../models/post_model.dart';
import '../../../../providers/view_count_provider.dart';
import '../../../common/widgets/app_drawer.dart';
import '../../../common/widgets/app_top_bar.dart';
import '../widgets/post_card.dart';

class BoardListScreen extends StatelessWidget {
  const BoardListScreen({super.key, required this.category});

  final BoardCategory category;

  @override
  Widget build(BuildContext context) {
    final ViewCountProvider viewCountProvider = context.watch<ViewCountProvider>();
    final List<PostModel> posts = viewCountProvider.getPosts(category);

    return Scaffold(
      appBar: AppTopBar(title: category.title),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.edit),
        label: const Text('글 작성'),
        onPressed: () => context.pushNamed(AppRoute.postEditor.name, extra: category),
      ),
      body: RefreshIndicator(
        onRefresh: () => viewCountProvider.fetchPostDataFromAPI(category.key),
        child: posts.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const <Widget>[
                  SizedBox(height: 120),
                  Center(child: Text('등록된 게시글이 없습니다. 첫 글을 작성해 보세요!')),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int index) {
                  final PostModel post = posts[index];
                  return PostCard(
                    post: post,
                    viewCountProvider: viewCountProvider,
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
