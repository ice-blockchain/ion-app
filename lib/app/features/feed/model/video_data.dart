import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_data.freezed.dart';

@Freezed(copyWith: true)
class VideoData with _$VideoData {
  const factory VideoData({
    required String videoUrl,
    required String imageUrl,
    required String authorName,
    required String authorImageUrl,
    required int likes,
    required bool isVertical,
    bool? liked,
  }) = _VideoData;
}
