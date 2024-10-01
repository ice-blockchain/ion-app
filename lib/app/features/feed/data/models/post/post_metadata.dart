// SPDX-License-Identifier: ice License 1.0

import 'package:ice/app/features/feed/data/models/post/post_media_data.dart';

class PostMetadata {
  const PostMetadata({
    this.media = const {},
  });

  final Map<String, PostMediaData> media;

  @override
  String toString() => 'PostMetadata(media: $media)';
}
