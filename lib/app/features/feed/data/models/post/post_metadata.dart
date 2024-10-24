// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/core/model/media_attachment.dart';

class PostMetadata {
  const PostMetadata({
    this.media = const {},
  });

  final Map<String, MediaAttachment> media;

  @override
  String toString() => 'PostMetadata(media: $media)';
}
