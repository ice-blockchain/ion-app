import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/generated/assets.gen.dart';

// Constants for custom embeds
const _kTextEditorCode = 'custom-code';

class TextEditorCodeEmbed extends CustomBlockEmbed {
  TextEditorCodeEmbed(String code) : super(_kTextEditorCode, code);
}

class TextEditorCodeBuilder extends EmbedBuilder {
  @override
  String get key => _kTextEditorCode;

  @override
  @override
  Widget build(BuildContext context, QuillController controller, Embed node, bool readOnly,
      bool inline, TextStyle textStyle) {
    final code = (node.value.data as String);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0.s),
        border: Border.all(
          color: context.theme.appColors.onTerararyFill,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.0.s, horizontal: 16.0.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0.s, vertical: 4.0.s),
                decoration: BoxDecoration(
                  color: context.theme.appColors.onTerararyFill,
                  borderRadius: BorderRadius.circular(16.0.s),
                ),
                child: Row(
                  children: [
                    Text(
                      "Dart",
                      style: context.theme.appTextThemes.caption.copyWith(
                        color: context.theme.appColors.primaryAccent,
                      ),
                    ),
                    Assets.svg.iconArrowDown.icon(
                      size: 14.0.s,
                      color: context.theme.appColors.primaryAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0.s),
          TextFormField(
            initialValue: code,
            readOnly: false,
            maxLines: 10,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            style: context.theme.appTextThemes.body2,
            // controller: TextEditingController(text: code),
          ),
        ],
      ),
    );
  }
}
