import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

const _kTextEditorDivider = 'custom-divider';

class TextEditorDividerEmbed extends CustomBlockEmbed {
  TextEditorDividerEmbed() : super(_kTextEditorDivider, '');
}

class TextEditorDividerBuilder extends EmbedBuilder {
  @override
  String get key => _kTextEditorDivider;

  @override
  Widget build(BuildContext context, QuillController controller, Embed node, bool readOnly,
      bool inline, TextStyle textStyle) {
    return Assets.svg.textEditorDivider.icon();
  }
}
