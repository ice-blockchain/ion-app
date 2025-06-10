// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as p;

part 'media_file.c.freezed.dart';
part 'media_file.c.g.dart';

@freezed
class MediaFile with _$MediaFile {
  const factory MediaFile({
    required String path,
    int? size,
    String? name,
    int? width,
    int? height,
    String? mimeType,
    String? thumb,
    String? blurhash,
    int? duration,
  }) = _MediaFile;

  const MediaFile._();

  factory MediaFile.fromJson(Map<String, dynamic> json) => _$MediaFileFromJson(json);

  String get basename => p.basename(path);
}
