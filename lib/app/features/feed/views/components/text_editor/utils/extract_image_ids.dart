import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';

List<String> extractImageIds(Delta delta) {
  final imageIds = <String>[];
  for (final operation in delta.operations) {
    final data = operation.data;
    if (data is Map<String, dynamic> && data.containsKey(textEditorSingleImageKey)) {
      imageIds.add(data[textEditorSingleImageKey] as String);
    }
  }
  return imageIds;
}
