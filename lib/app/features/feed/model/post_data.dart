import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/core/model/media_type.dart';
import 'package:ice/app/features/feed/model/post_media_data.dart';
import 'package:nostr_dart/nostr_dart.dart';

class PostData {
  PostData({
    required this.id,
    required this.body,
    required this.media,
  });

  factory PostData.fromEventMessage(EventMessage eventMessage) {
    return PostData(
      id: eventMessage.id,
      body: eventMessage.content,
      media: _parseEventMedia(eventMessage.tags),
    );
  }

  final String id;

  final String body;

  final List<PostMediaData> media;

  /// Parses a list of imeta tags (Media Attachments defined in NIP-92).
  ///
  /// Media attachments (images, videos, and other files) may be added to events
  /// by including a URL in the event content, along with a matching imeta tag.
  /// imeta ("inline metadata") tags add information about media URLs in the
  /// event's content.
  ///
  /// The imeta tag is variadic, and each entry is a space-delimited key/value pair.
  /// Each imeta tag MUST have a url, and at least one other field.
  /// imeta may include any field specified by NIP 94.
  ///
  /// Source: https://github.com/nostr-protocol/nips/blob/master/92.md
  ///
  /// TODO: parse content to include only assets that are there +
  /// populate from imeta
  /// When uploading files during a new post, clients MAY include this metadata
  /// after the file is uploaded and included in the post.
  /// When pasting URLs during post composition, the client MAY download the
  /// file and add this metadata before the post is sent.
  /// The client MAY ignore imeta tags that do not match the URL in the event
  /// content.
  static List<PostMediaData> _parseEventMedia(List<List<String>> tags) {
    return tags.fold<List<PostMediaData>>([], (result, tag) {
      if (tag[0] == 'imeta') {
        String? url;
        MediaType? mediaType;
        String? mimeType;
        String? blurhash;
        String? dimension;
        for (final params in tag.skip(1)) {
          final pair = params.split(' ');
          if (pair.length != 2) {
            continue;
          }
          final [key, value] = pair;
          switch (key) {
            case 'url':
              {
                if ((Uri.tryParse(value)?.isAbsolute).falseOrValue) {
                  url = value;
                }
              }
            case 'm':
              {
                mimeType = value;
                mediaType = MediaType.fromMimeType(mimeType.emptyOrValue);
              }
            case 'blurhash':
              blurhash = value;
            case 'dim':
              dimension = value;
          }
        }
        if (url != null) {
          result.add(
            PostMediaData(
              url: url,
              mediaType: mediaType == null || mediaType == MediaType.unknown
                  ? MediaType.fromUrl(url)
                  : mediaType,
              mimeType: mimeType,
              dimension: dimension,
              blurhash: blurhash,
            ),
          );
        }
      }
      return result;
    });
  }

  @override
  String toString() => 'PostData(id: $id, body: $body, media: $media)';
}
