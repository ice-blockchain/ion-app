// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:photo_manager/photo_manager.dart';

enum MediaPickerType {
  image,
  video,
  common;

  String title(BuildContext context) {
    return switch (this) {
      MediaPickerType.image => context.i18n.gallery_all_photos_title,
      MediaPickerType.video => context.i18n.common_all_video,
      MediaPickerType.common => context.i18n.gallery_all_media_title,
    };
  }
}

extension MediaPickerTypeMapper on MediaPickerType {
  RequestType toRequestType() {
    switch (this) {
      case MediaPickerType.image:
        return RequestType.image;
      case MediaPickerType.video:
        return RequestType.video;
      case MediaPickerType.common:
        return RequestType.common;
    }
  }
}
