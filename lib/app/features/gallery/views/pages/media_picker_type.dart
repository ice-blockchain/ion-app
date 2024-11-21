// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';

enum MediaPickerType {
  image,
  video,
  common;

  String title(BuildContext context) {
    return switch (this) {
      MediaPickerType.image => context.i18n.gallery_add_photo_title,
      MediaPickerType.video => context.i18n.common_add_video,
      MediaPickerType.common => context.i18n.gallery_add_media_title,
    };
  }
}
