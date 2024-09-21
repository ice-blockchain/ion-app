import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_manager/photo_manager.dart';

part 'image_data.freezed.dart';

@Freezed(copyWith: true)
class ImageData with _$ImageData {
  const factory ImageData({
    required AssetEntity asset,
    required int order,
    @Default(false) bool isFromCamera,
  }) = _ImageData;
}
