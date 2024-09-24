import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_manager/photo_manager.dart';

part 'media_data.freezed.dart';

@Freezed(copyWith: true, equal: true)
class MediaData with _$MediaData {
  const factory MediaData({
    required AssetEntity asset,
    required int order,
    @Default(false) bool isFromCamera,
  }) = _MediaData;
}
