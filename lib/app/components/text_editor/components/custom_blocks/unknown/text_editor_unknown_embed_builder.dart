// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

///
/// Embed builder for unknown embeds
///
class TextEditorUnknownEmbedBuilder extends EmbedBuilder {
  TextEditorUnknownEmbedBuilder();

  @override
  String get key => 'unknown-embed';

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    return const SizedBox.shrink();
  }
}
