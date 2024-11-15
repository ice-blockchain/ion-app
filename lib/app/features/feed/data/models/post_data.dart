// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/related_event.dart';
import 'package:ion/app/features/feed/data/models/entities/related_hashtag.dart';
import 'package:ion/app/features/feed/data/models/entities/related_pubkey.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/services/text_parser/matchers/hashtag_matcher.dart';
import 'package:ion/app/services/text_parser/matchers/url_matcher.dart';
import 'package:ion/app/services/text_parser/text_match.dart';
import 'package:ion/app/services/text_parser/text_parser.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'post_data.freezed.dart';

@Freezed(equal: false)
class PostEntity with _$PostEntity, NostrEntity implements CacheableEntity {
  const factory PostEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required PostData data,
  }) = _PostEntity;

  const PostEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/01.md
  factory PostEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    return PostEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      data: PostData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => cacheKeyBuilder(id: id);

  static String cacheKeyBuilder({required String id}) => id;

  static const kind = 1;
}

@freezed
class PostData with _$PostData implements EventSerializable {
  const factory PostData({
    required List<TextMatch> content,
    required Map<String, MediaAttachment> media,
    QuotedEvent? quotedEvent,
    List<RelatedEvent>? relatedEvents,
    List<RelatedPubkey>? relatedPubkeys,
    List<RelatedHashtag>? relatedHashtags,
  }) = _PostData;

  const PostData._();

  factory PostData.fromEventMessage(EventMessage eventMessage) {
    final parsedContent = TextParser(matchers: [const UrlMatcher()]).parse(eventMessage.content);
    final tags = eventMessage.tags.fold<Map<String, List<List<String>>>>({}, (result, tag) {
      return result..putIfAbsent(tag[0], () => []).add(tag);
    });
    return PostData(
      content: parsedContent,
      media: _buildMedia(tags[MediaAttachment.tagName], parsedContent),
      quotedEvent: _buildQuotedEvent(tags[QuotedEvent.tagName]),
      relatedEvents: tags[RelatedEvent.tagName]?.map(RelatedEvent.fromTag).toList(),
      relatedPubkeys: tags[RelatedPubkey.tagName]?.map(RelatedPubkey.fromTag).toList(),
      relatedHashtags: tags[RelatedHashtag.tagName]?.map(RelatedHashtag.fromTag).toList(),
    );
  }

  factory PostData.fromRawContent(String content) {
    final parsedContent = TextParser(matchers: [const UrlMatcher()]).parse(content);
    final hashtags = parsedContent
        .where((match) => match.matcherType is HashtagMatcher)
        .map((match) => RelatedHashtag(value: match.text))
        .toList();
    return PostData(
      content: parsedContent,
      relatedHashtags: hashtags,
      media: {},
    );
  }

  @override
  EventMessage toEventMessage(EventSigner signer) {
    return EventMessage.fromData(
      signer: signer,
      kind: PostEntity.kind,
      content: content.map((match) => match.text).join(),
      tags: [
        if (quotedEvent != null) quotedEvent!.toTag(),
        if (relatedPubkeys != null) ...relatedPubkeys!.map((pubkey) => pubkey.toTag()),
        if (relatedHashtags != null) ...relatedHashtags!.map((hashtag) => hashtag.toTag()),
        if (relatedEvents != null) ...relatedEvents!.map((event) => event.toTag()),
      ],
    );
  }

  static Map<String, MediaAttachment> _buildMedia(
    List<List<String>>? imetaTags,
    List<TextMatch> parsedContent,
  ) {
    if (imetaTags == null) {
      return {};
    }

    final imeta = _parseImeta(imetaTags);

    final media = parsedContent.fold<Map<String, MediaAttachment>>(
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
  static Map<String, MediaAttachment> _parseImeta(List<List<String>> imetaTags) {
    final imeta = <String, MediaAttachment>{};
    for (final tag in imetaTags) {
      if (tag[0] == 'imeta') {
        final mediaAttachment = MediaAttachment.fromTag(tag);
        imeta[mediaAttachment.url] = mediaAttachment;
      }
    }
    return imeta;
  }

  static QuotedEvent? _buildQuotedEvent(List<List<String>>? qTags) {
    if (qTags == null) {
      return null;
    }
    return QuotedEvent.fromTag(qTags.first);
  }

  @override
  String toString() {
    return 'PostData(${content.map((match) => match.text).join()})';
  }
}

@freezed
class QuotedEvent with _$QuotedEvent {
  const factory QuotedEvent({
    required String eventId,
    required String pubkey,
  }) = _QuotedEvent;

  const QuotedEvent._();

  /// https://github.com/nostr-protocol/nips/blob/master/18.md
  factory QuotedEvent.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    if (tag.length < 4) {
      //TODO::uncomment and remove stub when using own relays
      // throw IncorrectEventTagException(tag: tag.toString());
    }
    return QuotedEvent(
      eventId: tag[1],
      pubkey: /*tag[3]*/ '5e42daa682da9ad308e284b4a50b0967a23d6f352d2b819f40f0d9fa42a1b44d',
    );
  }

  List<String> toTag() {
    return [tagName, eventId, '', pubkey];
  }

  static const String tagName = 'q';
}
