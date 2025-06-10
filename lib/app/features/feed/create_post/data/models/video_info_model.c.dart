// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_info_model.c.freezed.dart';

@freezed
class VideoInfoModel with _$VideoInfoModel {
  const factory VideoInfoModel({
    required String name,
    required String originalSize,
    required String compressedSize,
    required String duration,
    required String size,
    required String fps,
    required String bitRate,
  }) = _VideoInfoModel;
}
