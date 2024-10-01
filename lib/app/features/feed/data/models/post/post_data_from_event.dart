// SPDX-License-Identifier: ice License 1.0

part of 'post_data.dart';

class _PostDataFromEvent extends PostData {
  _PostDataFromEvent(
    this.eventMessage,
  ) : super.fromRawContent(
          id: eventMessage.id,
          rawContent: eventMessage.content,
        );

  final EventMessage eventMessage;

  @override
  PostMetadata _buildMetadata() {
    final imeta = _parseImeta();

    final media = content.fold<Map<String, PostMediaData>>(
      {},
      (result, match) {
        final link = match.text;
        if (match.matcherType == UrlMatcher) {
          if (imeta.containsKey(link)) {
            result[link] = imeta[link]!;
          } else {
            final mediaType = MediaType.fromUrl(link);
            if (mediaType != MediaType.unknown) {
              result[link] = PostMediaData(url: link, mediaType: mediaType);
            }
          }
        }
        return result;
      },
    );
    return PostMetadata(media: media);
  }

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
  Map<String, PostMediaData> _parseImeta() {
    final tags = eventMessage.tags;
    final imeta = <String, PostMediaData>{};
    for (final tag in tags) {
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
          imeta[url] = PostMediaData(
            url: url,
            mediaType: mediaType == null || mediaType == MediaType.unknown
                ? MediaType.fromUrl(url)
                : mediaType,
            mimeType: mimeType,
            dimension: dimension,
            blurhash: blurhash,
          );
        }
      }
    }
    return imeta;
  }
}
