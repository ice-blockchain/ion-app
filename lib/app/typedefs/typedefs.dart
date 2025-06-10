// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/ion_connect/data/models/media_attachment.dart';
import 'package:ion/app/services/media_service/data/models/media_file.c.dart';

typedef OnVideoTapCallback = void Function({
  required String eventReference,
  required int initialMediaIndex,
  String? framedEventReference,
});

typedef AttachedMediaNotifier = ValueNotifier<List<MediaFile>>;
typedef AttachedMediaLinksNotifier = ValueNotifier<Map<String, MediaAttachment>>;
