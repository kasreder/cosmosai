// File: lib/features/board/presentation/screens/post_editor_screen.dart | Description: HTML 에디터를 활용한 게시글 작성/수정 화면.
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';

import '../../../../models/board_category.dart';
import '../../../../models/post_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/view_count_provider.dart';
import '../../../common/widgets/app_drawer.dart';
import '../../../common/widgets/app_top_bar.dart';

class PostEditorScreen extends StatefulWidget {
  const PostEditorScreen({
    super.key,
    required this.category,
    this.post,
  });

  final BoardCategory category;
  final PostModel? post;

  @override
  State<PostEditorScreen> createState() => _PostEditorScreenState();
}

class _PostEditorScreenState extends State<PostEditorScreen> {
  final HtmlEditorController _htmlController = HtmlEditorController();
  final TextEditingController _titleController = TextEditingController();
  final ValueNotifier<List<String>> _attachedImages = ValueNotifier<List<String>>(<String>[]);
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.post?.title ?? '';
    _attachedImages.value = List<String>.from(widget.post?.imageUrls ?? <String>[]);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.post != null) {
        await _htmlController.setText(widget.post!.content);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _attachedImages.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withReadStream: true,
    );
    if (result == null) {
      return;
    }
    final List<String> images = List<String>.from(_attachedImages.value);
    for (final PlatformFile file in result.files) {
      images.add('upload://${file.name}'); // 🖼️ 실제 업로드 시 백엔드 URL로 치환
      await _htmlController.insertNetworkImage('upload://${file.name}');
    }
    _attachedImages.value = images;
  }

  Future<void> _savePost() async {
    setState(() => _isSaving = true);
    final String content = await _htmlController.getText();
    final String title = _titleController.text.trim();
    if (title.isEmpty || content.isEmpty) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 내용을 모두 입력해주세요.')),
      );
      return;
    }

    final AuthProvider authProvider = context.read<AuthProvider>();
    final String nickname = authProvider.currentUser?.nickname ?? '익명 작성자';

    final PostModel newPost = (widget.post ?? PostModel(
          title: title,
          authorNickname: nickname,
          category: widget.category,
          content: content,
        ))
        .copyWith(
          title: title,
          content: content,
          imageUrls: _attachedImages.value,
        );

    await context.read<ViewCountProvider>().savePost(newPost);
    setState(() => _isSaving = false);
    if (mounted) {
      context.pop(newPost);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: '${widget.category.title} 글 작성'),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '제목을 입력하세요'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: HtmlEditor(
                controller: _htmlController,
                htmlEditorOptions: HtmlEditorOptions(
                  hint: '본문 내용을 HTML 형식으로 작성하세요.',
                  shouldEnsureVisible: true,
                ),
                htmlToolbarOptions: const HtmlToolbarOptions(
                  defaultToolbarButtons: <Object>[
                    FontButtons(),
                    ColorButtons(),
                    ListButtons(),
                    ParagraphButtons(),
                    InsertButtons(),
                  ],
                ),
                otherOptions: const OtherOptions(height: double.infinity),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                FilledButton.icon(
                  onPressed: _isSaving ? null : _pickImages,
                  icon: const Icon(Icons.image_outlined),
                  label: const Text('이미지 첨부'),
                ),
                const SizedBox(width: 12),
                ValueListenableBuilder<List<String>>(
                  valueListenable: _attachedImages,
                  builder: (BuildContext context, List<String> images, _) {
                    if (images.isEmpty) {
                      return const Text('첨부된 이미지가 없습니다.');
                    }
                    return Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: images
                              .map(
                                (String path) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Chip(
                                    label: Text(path.split('/').last),
                                    onDeleted: _isSaving
                                        ? null
                                        : () {
                                            final List<String> updated = List<String>.from(images)..remove(path);
                                            _attachedImages.value = updated;
                                          },
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: _isSaving ? null : _savePost,
                icon: _isSaving ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
                label: Text(_isSaving ? '저장 중...' : '저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
