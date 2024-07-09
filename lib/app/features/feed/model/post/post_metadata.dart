import 'package:ice/app/features/feed/model/post/post_media_data.dart';

class PostMetadata {
  const PostMetadata({
    this.media = const {},
  });

  final Map<String, PostMediaData> media;

  @override
  String toString() => 'PostMetadata(media: $media)';
}
