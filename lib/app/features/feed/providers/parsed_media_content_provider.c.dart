// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/attributes.dart';
import 'package:ion/app/features/feed/providers/mentioned_users_in_content_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/entity_data_with_media_content.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/services/markdown/quill.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'parsed_media_content_provider.c.g.dart';

@riverpod
Future<({Delta content, List<MediaAttachment> media, List<UserMetadataEntity?> mentionedUsers})>
    parsedMediaContent(
  Ref ref, {
  required EntityDataWithMediaContent data,
}) async {
  final EntityDataWithMediaContent(:content, :media, :richText) = data;

  Delta? delta;

  if (richText != null) {
    final richTextDecoded = Delta.fromJson(jsonDecode(richText.content) as List<dynamic>);
    final richTextDelta = processDelta(richTextDecoded);
    final mediaDelta = _parseMediaContentDelta(delta: richTextDelta, media: media);
    final mentionedUsers =
        await ref.watch(mentionedUsersInContentProvider(contentDelta: mediaDelta.content).future);
    final deltaWithMentions = _parseDeltaMentions(mediaDelta.content, mentionedUsers);
    return (
      content: processDeltaMatches(deltaWithMentions),
      media: mediaDelta.media,
      mentionedUsers: mentionedUsers.values.toList(),
    );
  }

  final isMarkdownContent = isMarkdown(content);

  if (isMarkdownContent) {
    delta = markdownToDelta(content);
  } else {
    delta = plainTextToDelta(content);
  }

  final mediaDeltaFallback = _parseMediaContentDelta(delta: delta, media: media);
  final mentionedUsers = await ref
      .watch(mentionedUsersInContentProvider(contentDelta: mediaDeltaFallback.content).future);
  final deltaWithMentions = _parseDeltaMentions(mediaDeltaFallback.content, mentionedUsers);
  return (
    content: processDeltaMatches(deltaWithMentions),
    media: mediaDeltaFallback.media,
    mentionedUsers: mentionedUsers.values.toList(),
  );
}

/// Parses the provided [delta] content to extract media links and separate them from non-media content.
///
/// Parameters:
/// - [delta]: The [Delta] object representing the content to be parsed.
/// - [media]: A map of all available media links.
///
/// Returns:
/// - [content]: A new [Delta] object with non-media operations.
/// - [media]: A list of [MediaAttachment] objects extracted from the content.
({Delta content, List<MediaAttachment> media}) _parseMediaContentDelta({
  required Delta delta,
  required Map<String, MediaAttachment> media,
}) {
  if (media.isEmpty) return (content: delta, media: []);

  final mediaFromContent = <MediaAttachment>[];
  final nonMediaOperations = <Operation>[];

  var afterMedia = false;
  for (final operation in delta.operations) {
    final attributes = operation.attributes;
    if (attributes != null &&
        attributes.containsKey(Attribute.link.key) &&
        media.containsKey(attributes[Attribute.link.key])) {
      afterMedia = true;
      mediaFromContent.add(media[attributes[Attribute.link.key]]!);
    } else {
      // [afterMedia] and [trimmedValue] are needed to handle the case with
      // processing Delta, that is built upon a plain text -
      // there we insert media links as plain text in the beginning of the content,
      // dividing those with a whitespace.
      // After the links are extracted, we need to remove the whitespaces as well.
      final value = operation.value as String;
      final trimmedValue =
          afterMedia && value.startsWith(' ') ? value.replaceFirst(' ', '') : value;
      afterMedia = false;

      if (trimmedValue.isNotEmpty) {
        // Preserve original attributes for non-media content
        nonMediaOperations.add(
          operation.attributes != null
              ? Operation.insert(trimmedValue, operation.attributes)
              : Operation.insert(trimmedValue),
        );
      }
    }
  }

  return (content: Delta.fromOperations(nonMediaOperations), media: mediaFromContent);
}

Delta _parseDeltaMentions(Delta delta, Map<String, UserMetadataEntity?> mentionedUsers) {
  return Delta.fromOperations(
    delta.operations.map((operation) {
      if (operation.hasAttribute(MentionAttribute.attributeKey)) {
        final encodedReference = operation.value as String;
        final userMetadata = mentionedUsers[encodedReference];
        if (userMetadata == null) return operation;
        return Operation.insert('@${userMetadata.data.name}', operation.attributes);
      }
      return operation;
    }).toList(),
  );
}

bool isMarkdown(String text) {
  // Common markdown patterns
  final patterns = [
    // Headers
    RegExp(r'^#{1,6}\s'),
    // Lists
    RegExp(r'^[-*+]\s'),
    RegExp(r'^\d+\.\s'),
    // Links
    RegExp(r'\[.*?\]\(.*?\)'),
    // Bold/Italic
    RegExp('[*_]{1,2}.*?[*_]{1,2}'),
    // Code blocks
    RegExp('`{1,3}.*?`{1,3}'),
    // Blockquotes
    RegExp(r'^\s*>\s'),
    // Tables
    RegExp(r'\|.*\|'),
    // Escaped characters
    RegExp(r'\\[\\`*_{}\[\]()#+\-.!]'),
  ];

  return patterns.any((pattern) => pattern.hasMatch(text));
}
