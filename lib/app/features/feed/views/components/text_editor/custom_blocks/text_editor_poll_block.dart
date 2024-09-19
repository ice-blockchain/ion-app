import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

const _kTextEditorPollBlock = 'custom-create-poll';

class TextEditorPollBlockEmbed extends CustomBlockEmbed {
  TextEditorPollBlockEmbed() : super(_kTextEditorPollBlock, '');
}

class TextEditorPollBlockBuilder extends EmbedBuilder {
  @override
  String get key => _kTextEditorPollBlock;

  @override
  Widget build(BuildContext context, QuillController controller, Embed node, bool readOnly,
      bool inline, TextStyle textStyle) {
    //generate a poll component with options
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text('Poll'),
          TextField(
            decoration: InputDecoration(hintText: 'Option 1'),
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Option 2'),
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Option 3'),
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Option 4'),
          ),
        ],
      ),
    );
  }
}
