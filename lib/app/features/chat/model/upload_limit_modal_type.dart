import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

enum UploadLimitModalType {
  file,
  video;

  String getDescription(BuildContext context) {
    return switch (this) {
      UploadLimitModalType.file => context.i18n.file_upload_limit_modal_description,
      UploadLimitModalType.video => context.i18n.video_upload_limit_modal_description,
    };
  }
}
