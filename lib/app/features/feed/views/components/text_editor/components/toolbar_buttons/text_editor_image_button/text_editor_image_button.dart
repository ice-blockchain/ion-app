// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/app/features/feed/views/components/permission_dialogs/gallery_denied_dialog.dart';
import 'package:ice/app/features/feed/views/components/permission_dialogs/gallery_request_dialog.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block.dart';
import 'package:ice/app/hooks/use_hide_keyboard_and_call_once.dart';
import 'package:ice/app/hooks/use_permission_handler.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/services/media_service/media_service.dart';
import 'package:ice/generated/assets.gen.dart';

class TextEditorImageButton extends HookConsumerWidget {
  const TextEditorImageButton({required this.textEditorController, super.key});
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handlePhotoPermission = usePermissionHandler(
      ref,
      AppPermissionType.photos,
      requestDialog: const GalleryRequestDialog(),
      deniedDialog: const GalleryDeniedDialog(),
    );

    final hideKeyboardAndCallOnce = useHideKeyboardAndCallOnce();

    return ActionsToolbarButton(
      icon: Assets.svg.iconGalleryOpen,
      onPressed: () async {
        final hasPermission = await handlePhotoPermission();

        hideKeyboardAndCallOnce(
          callback: () async {
            if (hasPermission && context.mounted) {
              await MediaPickerRoute().push<List<MediaFile>>(context);
              addSingleImageBlock(textEditorController);
            }
          },
        );
      },
    );
  }

  void addSingleImageBlock(QuillController textEditorController) {
    final index = textEditorController.selection.baseOffset;
    textEditorController
      ..replaceText(
        index,
        0, // No text to delete
        TextEditorSingleImageEmbed.image('https://picsum.photos/600/300'),
        TextSelection.collapsed(
          offset: textEditorController.document.length,
        ), // Move cursor to the end of the document
      )
      ..replaceText(
        index + 1,
        0,
        '\n',
        TextSelection.collapsed(offset: textEditorController.document.length),
      );
  }
}
