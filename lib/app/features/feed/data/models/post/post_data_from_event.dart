// SPDX-License-Identifier: ice License 1.0

part of 'post_data.dart';

class _PostDataFromEvent extends PostData {
  _PostDataFromEvent(
    this.eventMessage,
  ) : super.fromRawContent(rawContent: eventMessage.content);

  final EventMessage eventMessage;

  @override
  PostMetadata _buildMetadata() {
    final imeta = _parseImeta();

    final media = content.fold<Map<String, MediaAttachment>>(
      {},
      (result, match) {
        final link = match.text;
        if (match.matcherType == UrlMatcher) {
          if (imeta.containsKey(link)) {
            result[link] = imeta[link]!;
          } else {
            result[link] = MediaAttachment(url: link);
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
  Map<String, MediaAttachment> _parseImeta() {
    final tags = eventMessage.tags;
    final imeta = <String, MediaAttachment>{};
    for (final tag in tags) {
      if (tag[0] == 'imeta') {
        final mediaAttachment = MediaAttachment.fromTag(tag);
        imeta[mediaAttachment.url] = mediaAttachment;
      }
    }
    return imeta;
  }
}
