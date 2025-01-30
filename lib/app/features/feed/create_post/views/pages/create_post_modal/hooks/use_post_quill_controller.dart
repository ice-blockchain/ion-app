// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/services/quill/attributes.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';

QuillController? usePostQuillController(
  WidgetRef ref, {
  String? content,
  EventReference? modifiedEvent,
}) {
  final modifiedEntity = modifiedEvent != null
      ? ref.watch(ionConnectEntityProvider(eventReference: modifiedEvent)).valueOrNull
      : null;

  return useMemoized(
    () {
      if (content != null) {
        final document = Document.fromDelta(Delta.fromJson(jsonDecode(content) as List<dynamic>));
        return QuillController(
          document: document,
          selection: TextSelection.collapsed(offset: document.length - 1),
        );
      }
      if (modifiedEntity != null) {
        if (modifiedEntity is ModifiablePostEntity) {
          final content = modifiedEntity.data.contentWithoutMedia;
          final document = Document.fromDelta(
            Delta.fromOperations(
              [
                ...content.map((match) {
                  if (match.matcher is HashtagMatcher) {
                    return Operation.insert(
                      match.text,
                      HashtagAttribute.withValue(match.text).toJson(),
                    );
                  } else {
                    return Operation.insert(match.text);
                  }
                }),
                Operation.insert('\n'),
              ],
            ),
          );
          return QuillController(
            document: document,
            selection: TextSelection.collapsed(offset: document.length - 1),
          );
        }
        return null;
      }
      return QuillController.basic();
    },
    [content, modifiedEntity],
  );
}
