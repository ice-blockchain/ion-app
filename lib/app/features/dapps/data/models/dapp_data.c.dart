// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'dapp_data.c.freezed.dart';

@freezed
class DAppData with _$DAppData {
  const factory DAppData({
    required String iconImage,
    required String title,
    required int identifier,
    @Default(false) bool isFavourite,
    @Default(false) bool isFeatured,
    @Default(0.0) double? value,
    @Default(false) bool isVerified,
    String? backgroundImage,
    String? link,
    String? description,
    String? fullDescription,
  }) = _DAppData;
}
