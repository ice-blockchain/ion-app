import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

const _kTextEditorSingleImage = 'custom-image';

class TextEditorSingleImageEmbed extends CustomBlockEmbed {
  TextEditorSingleImageEmbed(String imageUrl) : super(_kTextEditorSingleImage, imageUrl);

  static BlockEmbed image(String imageUrl) => TextEditorSingleImageEmbed(imageUrl);
}

class TextEditorSingleImageBuilder extends EmbedBuilder {
  @override
  String get key => _kTextEditorSingleImage;

  @override
  Widget build(BuildContext context, QuillController controller, Embed node, bool readOnly,
      bool inline, TextStyle textStyle) {
    final String imageUrl = node.value.data as String;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error);
        },
      ),
    );
  }
}
