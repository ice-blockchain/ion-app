// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/core/model/media_metadata.dart';

class PostMetadata {
  const PostMetadata({
    this.media = const {},
  });

  final Map<String, MediaMetadata> media;

  @override
  String toString() => 'PostMetadata(media: $media)';
}
