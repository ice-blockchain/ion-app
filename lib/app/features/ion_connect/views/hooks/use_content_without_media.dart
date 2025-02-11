// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/services/markdown/quill.dart';

Delta useContentWithoutMedia({
  required EntityDataWithMediaContent data,
}) {
  return useMemoized(
    () => contentWithoutMedia(data: data),
    [data],
  );
}

Delta contentWithoutMedia({
  required EntityDataWithMediaContent data,
}) {
  final EntityDataWithMediaContent(:content, :media) = data;
  final delta = markdownToDelta(content);

  if (media.isEmpty) return delta;

  //TODO:impl

  return delta;
}
