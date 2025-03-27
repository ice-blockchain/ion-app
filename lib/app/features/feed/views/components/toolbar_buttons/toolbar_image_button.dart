// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/components/text_editor/components/gallery_permission_button.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

abstract class ToolbarImageButtonDelegate {
  void onMediaSelected(List<MediaFile>? mediaFiles) {
    if (mediaFiles != null && mediaFiles.isNotEmpty) {
      handleSelectedMedia(mediaFiles);
    }
  }

  void handleSelectedMedia(List<MediaFile> files);
}

///
/// Handles and stores attached media files using a [attachedMediaNotifier].
///
class AttachedMediaHandler extends ToolbarImageButtonDelegate {
  AttachedMediaHandler(this._attachedMediaNotifier);

  final ValueNotifier<List<MediaFile>> _attachedMediaNotifier;

  @override
  void handleSelectedMedia(List<MediaFile> files) {
    files.forEach(_attachedMediaNotifier.value.add);
  }
}

///
/// Integrates selected media into a text using single image block and QuillController.
///
class QuillControllerHandler extends ToolbarImageButtonDelegate {
  QuillControllerHandler(this._textEditorController);

  final QuillController _textEditorController;

  @override
  void handleSelectedMedia(List<MediaFile> files) {
    for (final file in files) {
      final index = _textEditorController.selection.baseOffset;
      _textEditorController
        ..replaceText(
          index,
          0,
          TextEditorSingleImageEmbed.image(file.path),
          TextSelection.collapsed(
            offset: _textEditorController.document.length,
          ),
        )
        ..replaceText(
          index + 1,
          0,
          '\n',
          TextSelection.collapsed(offset: _textEditorController.document.length),
        );
    }
  }
}

class ToolbarImageButton extends StatelessWidget {
  const ToolbarImageButton({
    required this.delegate,
    this.maxImages,
    this.enabled = true,
    super.key,
  });

  final ToolbarImageButtonDelegate delegate;
  final int? maxImages;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GalleryPermissionButton(
      mediaPickerType: MediaPickerType.image,
      onMediaSelected: delegate.onMediaSelected,
      maxSelection: maxImages,
      enabled: enabled,
    );
  }
}
