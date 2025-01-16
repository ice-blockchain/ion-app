// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/services/text_parser/model/text_match.c.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';

mixin EntityMediaDataMixin {
  List<TextMatch> get content;
  Map<String, MediaAttachment> get media;

  List<TextMatch> get contentWithoutMedia {
    if (media.isEmpty) return content;

    final result = <TextMatch>[];
    TextMatch? previousMatch;

    // Post-process text to remove leading space after media URLs
    for (final match in content) {
      if (match.matcher == null &&
          previousMatch?.matcher is UrlMatcher &&
          media.containsKey(previousMatch?.text) &&
          match.text.startsWith(' ')) {
        result.add(
          match.copyWith(
            text: match.text.substring(1),
            offset: match.offset + 1,
          ),
        );
      } else {
        result.add(match);
      }

      previousMatch = match;
    }

    // Filter out URLs from the text content that are present in the media attachments
    // to avoid showing media URLs in the text when they're already being displayed as actual media
    return result.where((match) {
      return !media.values.any((media) => media.url == match.text);
    }).toList();
  }

  MediaAttachment? get primaryMedia => media.values.firstOrNull;

  MediaAttachment? get primaryVideo =>
      media.values.firstWhereOrNull((media) => media.mediaType == MediaType.video);

  static Map<String, MediaAttachment> buildMedia(
    List<List<String>>? imetaTags,
    List<TextMatch> parsedContent,
  ) {
    if (imetaTags == null) {
      return {};
    }

    final imeta = parseImeta(imetaTags);

    final media = parsedContent.fold<Map<String, MediaAttachment>>(
      {},
      (result, match) {
        final link = match.text;
        if (match.matcher is UrlMatcher && imeta.containsKey(link)) {
          result[link] = imeta[link]!;
        }
        return result;
      },
    );
    return media;
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
  static Map<String, MediaAttachment> parseImeta(List<List<String>>? imetaTags) {
    if (imetaTags == null) {
      return {};
    }

    final imeta = <String, MediaAttachment>{};
    for (final tag in imetaTags) {
      if (tag[0] == 'imeta') {
        final mediaAttachment = MediaAttachment.fromTag(tag);
        imeta[mediaAttachment.url] = mediaAttachment;
      }
    }
    return imeta;
  }
}
