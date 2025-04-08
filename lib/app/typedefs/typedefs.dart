// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

typedef OnVideoTapCallback = void Function({
  required String eventReference,
  required int initialMediaIndex,
  String? framedEventReference,
});

typedef AttachedMediaNotifier = ValueNotifier<List<MediaFile>>;
typedef AttachedMediaLinksNotifier = ValueNotifier<Map<String, MediaAttachment>>;
typedef MentionsMapNotifier = ValueNotifier<Map<String, String>>;
