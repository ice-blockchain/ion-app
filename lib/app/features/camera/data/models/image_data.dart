import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_data.freezed.dart';

@Freezed(copyWith: true)
class ImageData with _$ImageData {
  const factory ImageData({
    required String id,
    Uint8List? thumbData,
    required int order,
    @Default(false) bool isFromCamera,
  }) = _ImageData;
}
