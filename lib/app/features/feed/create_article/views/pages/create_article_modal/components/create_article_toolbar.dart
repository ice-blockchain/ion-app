// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_modal/components/Article_typography_toolbar.dart';
import 'package:ion/app/features/feed/create_article/views/pages/create_article_modal/components/article_main_toolbar.dart';

class CreateArticleToolbar extends HookWidget {
  const CreateArticleToolbar({
    required this.textEditorController,
    super.key,
  });

  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    final isTypographyToolbarVisible = useState(false);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isTypographyToolbarVisible.value
          ? ArticleTypographyToolbar(
              textEditorController: textEditorController,
              onClosePressed: () {
                isTypographyToolbarVisible.value = false;
              },
            )
          : ArticleMainToolbar(
              textEditorController: textEditorController,
              onTypographyPressed: () {
                isTypographyToolbarVisible.value = true;
              },
            ),
    );
  }
}
