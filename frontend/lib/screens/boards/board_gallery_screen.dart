// File: frontend/lib/screens/boards/board_gallery_screen.dart
// Description: Gallery-style board screen displaying posts with images in a responsive grid.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/board_provider.dart';
import '../../widgets/board/post_card.dart';

/// Gallery screen showing posts with large previews.
class BoardGalleryScreen extends StatelessWidget {
  /// Default constructor.
  const BoardGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BoardProvider boardProvider = context.watch<BoardProvider>();
    final int crossAxisCount = _calculateCrossAxisCount(MediaQuery.of(context).size.width);

    return Scaffold(
      appBar: AppBar(
        title: const Text('게시판 · 액자형'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: boardProvider.galleryPosts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (BuildContext context, int index) {
            return PostCard(post: boardProvider.galleryPosts[index]);
          },
        ),
      ),
    );
  }

  /// Determines how many columns to display based on screen width.
  int _calculateCrossAxisCount(double width) {
    if (width >= 1200) {
      return 4;
    }
    if (width >= 900) {
      return 3;
    }
    if (width >= 600) {
      return 2;
    }
    return 1;
  }
}
