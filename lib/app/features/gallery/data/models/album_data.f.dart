// SPDX-License-Identifier: ice License 1.0
import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_data.f.freezed.dart';

@freezed
class AlbumData with _$AlbumData {
  const factory AlbumData({
    required String id,
    required String name,
    required int assetCount,
    @Default(false) bool isAll,
  }) = _AlbumData;
}
