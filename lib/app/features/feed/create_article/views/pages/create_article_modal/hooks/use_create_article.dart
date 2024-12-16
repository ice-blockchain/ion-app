// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/article/create_article_provider.c.dart';
import 'package:ion/app/features/feed/views/components/text_editor/hooks/use_quill_controller.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class CreateArticleState {
  CreateArticleState({
    required this.selectedImage,
    required this.titleFilled,
    required this.titleController,
    required this.textEditorController,
    required this.isButtonEnabled,
    required this.editorFocusNotifier,
    required this.onNext,
  });
  final ValueNotifier<MediaFile?> selectedImage;
  final ValueNotifier<bool> titleFilled;
  final TextEditingController titleController;
  final QuillController textEditorController;
  final bool isButtonEnabled;
  final ValueNotifier<bool> editorFocusNotifier;
  final void Function(WidgetRef ref) onNext;
}

CreateArticleState useCreateArticle() {
  final selectedImage = useState<MediaFile?>(null);
  final titleFilled = useState(false);
  final textEditorController = useQuillController();
  final editorFocusNotifier = useState<bool>(false);

  final titleController = useTextEditingController();
  final isButtonEnabled = selectedImage.value != null && titleFilled.value;

  useEffect(
    () {
      void listener() {
        titleFilled.value = titleController.text.trim().isNotEmpty;
      }

      titleController.addListener(listener);
      return () => titleController.removeListener(listener);
    },
    [titleController],
  );

  void onNext(WidgetRef ref) {
    ref.read(createArticleProvider.notifier).updateImage(selectedImage.value);
    ref.read(createArticleProvider.notifier).updateTitle(titleController.text);
    ref.read(createArticleProvider.notifier).updateContent(textEditorController);
    ref.read(createArticleProvider.notifier).updateOperationsAndImageIds(textEditorController);
  }

  return CreateArticleState(
    selectedImage: selectedImage,
    titleFilled: titleFilled,
    titleController: titleController,
    textEditorController: textEditorController,
    isButtonEnabled: isButtonEnabled,
    editorFocusNotifier: editorFocusNotifier,
    onNext: onNext,
  );
}
