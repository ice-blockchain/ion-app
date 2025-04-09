// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/quill_delta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/attributes.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reference_encoded_mentions_operations_provider.c.g.dart';

@riverpod
Future<List<Operation>> referenceEncodedMentionsOperations(
  Ref ref,
  List<Operation> operations, {
  required Map<String, String> mentions,
}) {
  return Future.wait(
    operations
        .map((operation) => _getMappedMentionOperation(ref, operation, mentions: mentions))
        .toList(),
  );
}

Future<Operation> _getMappedMentionOperation(
  Ref ref,
  Operation operation, {
  required Map<String, String> mentions,
}) async {
  if (!operation.hasAttribute(MentionAttribute.attributeKey) ||
      operation.data is! String ||
      !(operation.data! as String).startsWith('@')) {
    return operation;
  }
  final username = operation.data! as String;
  final pubkey = mentions[username];
  if (pubkey == null) {
    return operation;
  }
  final userMetadata = await ref.read(userMetadataProvider(pubkey).future);
  if (userMetadata == null) {
    return operation;
  }
  final userMetadataEncoded = userMetadata.toEventReference().encode();
  return Operation.insert(
    userMetadataEncoded,
    operation.attributes,
  );
}
