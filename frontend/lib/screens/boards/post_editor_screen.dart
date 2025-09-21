// File: frontend/lib/screens/boards/post_editor_screen.dart
// Description: HTML editor screen for creating and updating posts with image URL attachments.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:html_editor_enhanced/html_editor_enhanced.dart';
import 'package:provider/provider.dart';

import '../../models/board_category.dart';
import '../../models/board_post.dart';
import '../../providers/auth_provider.dart';
import '../../providers/board_provider.dart';

/// Post editor supporting HTML based content editing.
class PostEditorScreen extends StatefulWidget {
  /// Creates the editor for the given post id ("new" for creation).
  const PostEditorScreen({super.key, required this.postId});

  /// Identifier of the post to edit or 'new' for creation.
  final String postId;

  @override
  State<PostEditorScreen> createState() => _PostEditorScreenState();
}

class _PostEditorScreenState extends State<PostEditorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageUrlsController = TextEditingController();
  BoardCategory _selectedCategory = BoardCategory.free;
  final HtmlEditorController _htmlController = HtmlEditorController();

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlsController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _prefillIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = context.watch<AuthProvider>();
    final bool canEdit = authProvider.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postId == 'new' ? '새 글 작성' : '글 수정'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: canEdit ? () => _handleSave(context) : null,
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text('저장', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: AbsorbPointer(
        absorbing: !canEdit,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '제목'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력해 주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<BoardCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: '카테고리'),
                onChanged: (BoardCategory? value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
                items: BoardCategory.values
                    .map((BoardCategory category) => DropdownMenuItem<BoardCategory>(
                          value: category,
                          child: Text(category.label),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imageUrlsController,
                decoration: const InputDecoration(
                  labelText: '이미지 URL (콤마로 구분)',
                  hintText: 'https://example.com/a.png, https://example.com/b.png',
                ),
              ),
              const SizedBox(height: 12),
              Text('본문 (HTML)', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SizedBox(
                height: 360,
                child: HtmlEditor(
                  controller: _htmlController,
                  htmlEditorOptions: HtmlEditorOptions(
                    hint: '본문을 입력해 주세요',
                    autoAdjustHeight: false,
                  ),
                  callbacks: Callbacks(
                    // Placeholder for future image upload integration.
                    onImageUpload: (FileUpload? file) async {
                      // 실제 업로드 로직을 연결할 때 여기에 구현합니다.
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Prefills the form fields when editing an existing post.
  void _prefillIfNeeded() {
    final BoardProvider boardProvider = context.read<BoardProvider>();
    if (widget.postId == 'new') {
      return;
    }
    final BoardPost? post = boardProvider.getPostById(widget.postId);
    if (post == null) {
      return;
    }
    _titleController.text = post.title;
    _selectedCategory = post.category;
    _imageUrlsController.text = post.imageUrls.join(', ');
    _htmlController.setText(post.contentHtml);
  }

  Future<void> _handleSave(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final BoardProvider boardProvider = context.read<BoardProvider>();
    final AuthProvider authProvider = context.read<AuthProvider>();
    final String html = await _htmlController.getText();
    final List<String> imageUrls = _imageUrlsController.text
        .split(',')
        .map((String url) => url.trim())
        .where((String url) => url.isNotEmpty)
        .toList();

    if (widget.postId == 'new') {
      final BoardPost post = BoardPost(
        id: 'post-${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text,
        authorNickname: authProvider.currentUser?.nickname ?? '익명',
        viewCount: 0,
        contentHtml: html,
        category: _selectedCategory,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        imageUrls: imageUrls,
      );
      boardProvider.createPost(post);
    } else {
      final BoardPost? existing = boardProvider.getPostById(widget.postId);
      if (existing != null) {
        boardProvider.updatePost(existing.copyWith(
          title: _titleController.text,
          contentHtml: html,
          imageUrls: imageUrls,
        ));
      }
    }

    if (mounted) {
      context.pop();
    }
  }
}
