// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/hooks/use_quill_controller.dart';
import 'package:ion/app/features/feed/create_article/providers/draft_article_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/user/providers/image_proccessor_notifier.c.dart';
import 'package:ion/app/services/media_service/image_proccessing_config.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class ArticleFormState {
  ArticleFormState({
    required this.selectedImage,
    required this.selectedImageUrl,
    required this.titleFilled,
    required this.titleController,
    required this.textEditorController,
    required this.isButtonEnabled,
    required this.editorFocusNotifier,
    required this.onNext,
    required this.titleInputFormatters,
    required this.titleFocusNode,
    required this.isTitleFocused,
  });

  final ValueNotifier<MediaFile?> selectedImage;
  final ValueNotifier<String?> selectedImageUrl;
  final ValueNotifier<bool> titleFilled;
  final TextEditingController titleController;
  final QuillController textEditorController;
  final bool isButtonEnabled;
  final ValueNotifier<bool> editorFocusNotifier;
  final void Function() onNext;
  final List<TextInputFormatter> titleInputFormatters;
  final FocusNode titleFocusNode;
  final ValueNotifier<bool> isTitleFocused;
}

ArticleFormState useArticleForm(WidgetRef ref, {EventReference? modifiedEvent}) {
  final selectedImage = useState<MediaFile?>(null);
  final selectedImageUrl = useState<String?>(null);
  final selectedImageUrlColor = useState<String?>(null);
  final titleFilled = useState(false);
  final textEditorController = useQuillController();
  final editorFocusNotifier = useState<bool>(false);
  final titleController = useTextEditingController();
  final titleFocusNode = useFocusNode();
  final isTitleFocused = useState(false);
  final isTextValid = useState(false);
  const titleMaxLength = 120;

  useEffect(
    () {
      void onFocusChange() {
        isTitleFocused.value = titleFocusNode.hasFocus;
      }

      titleFocusNode.addListener(onFocusChange);
      return () => titleFocusNode.removeListener(onFocusChange);
    },
    [titleFocusNode],
  );

  final titleInputFormatters = useMemoized(
    () => [
      LengthLimitingTextInputFormatter(titleMaxLength),
      TextInputFormatter.withFunction((oldValue, newValue) {
        if (newValue.text.length > oldValue.text.length + 1 &&
            newValue.text.length > titleMaxLength) {
          return oldValue;
        }
        return newValue;
      }),
    ],
    [titleMaxLength],
  );

  final processorState =
      ref.watch(imageProcessorNotifierProvider(ImageProcessingType.articleCover));

  useEffect(
    () {
      processorState.whenOrNull(
        processed: (file) {
          selectedImage.value = file;
        },
      );
      return;
    },
    [processorState],
  );

  useEffect(
    () {
      if (modifiedEvent != null) {
        final modifiableEntity =
            ref.read(ionConnectEntityProvider(eventReference: modifiedEvent)).valueOrNull;

        if (modifiableEntity is ArticleEntity) {
          if (modifiableEntity.data.title != null) {
            titleController.text = modifiableEntity.data.title!;
            titleFilled.value = true;
          }

          if (modifiableEntity.data.richText?.protocol == 'quill_delta' &&
              modifiableEntity.data.richText?.content != null) {
            try {
              final content = jsonDecode(modifiableEntity.data.richText!.content);
              if (content is List) {
                textEditorController.document = Document.fromJson(content);
                isTextValid.value = true;
              }
            } catch (e) {
              debugPrint('Error parsing rich text: $e');
            }
          }

          if (modifiableEntity.data.image != null) {
            selectedImageUrl.value = modifiableEntity.data.image;
            selectedImageUrlColor.value = modifiableEntity.data.colorLabel?.value;
          }
        }
      }
      return null;
    },
    [modifiedEvent],
  );

  useEffect(
    () {
      void listener() {
        if (titleController.text.length > titleMaxLength) {
          titleController
            ..text = titleController.text.substring(0, titleMaxLength)
            ..selection = TextSelection.fromPosition(
              const TextPosition(offset: titleMaxLength),
            );
        }

        titleFilled.value = titleController.text.trim().isNotEmpty;
      }

      titleController.addListener(listener);
      return () => titleController.removeListener(listener);
    },
    [titleController],
  );

  useEffect(
    () {
      void listener() {
        isTextValid.value = textEditorController.document.toPlainText().trim().isNotEmpty;
      }

      textEditorController.addListener(listener);
      return () => textEditorController.removeListener(listener);
    },
    [textEditorController],
  );

  void onNext() {
    ref.read(draftArticleProvider.notifier).updateArticleDetails(
          textEditorController,
          selectedImage.value,
          titleController.text,
          selectedImageUrl.value,
          selectedImageUrlColor.value,
        );
  }

  final isButtonEnabled = useMemoized(
    () {
      return (selectedImage.value != null || selectedImageUrl.value != null) &&
          titleFilled.value &&
          isTextValid.value;
    },
    [selectedImage.value, selectedImageUrl.value, titleFilled.value, isTextValid.value],
  );

  return ArticleFormState(
    selectedImage: selectedImage,
    selectedImageUrl: selectedImageUrl,
    titleFilled: titleFilled,
    titleController: titleController,
    textEditorController: textEditorController,
    isButtonEnabled: isButtonEnabled,
    editorFocusNotifier: editorFocusNotifier,
    onNext: onNext,
    titleInputFormatters: titleInputFormatters,
    titleFocusNode: titleFocusNode,
    isTitleFocused: isTitleFocused,
  );
}
