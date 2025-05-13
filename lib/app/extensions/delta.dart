// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_profile_block/text_editor_profile_block.dart';
import 'package:ion/app/components/text_editor/utils/is_attributed_operation.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

extension DeltaExt on Delta {
  List<String> extractPubkeys() {
    final pubkeys = <String>[];
    for (final op in operations) {
      if (op.key == 'insert' && op.data is Map) {
        final attributes = op.data! as Map<String, dynamic>;
        if (attributes.containsKey(textEditorProfileKey)) {
          final encodedRef = attributes[textEditorProfileKey] as String;
          final eventReference = EventReference.fromEncoded(encodedRef);
          pubkeys.add(eventReference.pubkey);
        }
      }
    }
    return pubkeys;
  }

  bool get isSingleLinkOnly {
    return operations.length == 2 &&
        isAttributedOperation(operations.first, attribute: Attribute.link) &&
        operations.last.data == '\n';
  }
}
