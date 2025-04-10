// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_profile_block/profile_block.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';

const textEditorProfileKey = 'text-editor-profile';

///
/// Embeds a profile in the text editor.
///
class TextEditorProfileEmbed extends CustomBlockEmbed {
  TextEditorProfileEmbed(String encodedReference) : super(textEditorProfileKey, encodedReference);

  static BlockEmbed profileBlock(String encodedReference) =>
      TextEditorProfileEmbed(encodedReference);
}

///
/// Embed builder for [TextEditorProfileEmbed].
///
class TextEditorProfileBuilder extends EmbedBuilder {
  TextEditorProfileBuilder();

  @override
  String get key => textEditorProfileKey;

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    final encodedReference = embedContext.node.value.data as String;
    final reference = EventReference.fromEncoded(encodedReference);

    return ProfileBlock(reference: reference);
  }
}
