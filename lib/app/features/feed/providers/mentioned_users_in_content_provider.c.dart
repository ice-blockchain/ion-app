// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/quill_delta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/attributes.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mentioned_users_in_content_provider.c.g.dart';

@riverpod
Future<Map<String, UserMetadataEntity?>> mentionedUsersInContent(
  Ref ref, {
  required Delta contentDelta,
}) async {
  final operations = contentDelta.operations;
  final mentionsOperations =
      operations.where((operation) => operation.hasAttribute(MentionAttribute.attributeKey));
  if (mentionsOperations.isEmpty) {
    return const {};
  }

  final mentionedUsers = await Future.wait(
    mentionsOperations.map(
      (operation) async {
        final encodedReference = operation.value as String;
        final reference = EventReference.fromEncoded(encodedReference);
        final userMetadata =
            await ref.watch(ionConnectEntityProvider(eventReference: reference).future)
                as UserMetadataEntity?;

        return MapEntry(
          encodedReference,
          userMetadata,
        );
      },
    ),
  );

  return Map.fromEntries(mentionedUsers);
}
