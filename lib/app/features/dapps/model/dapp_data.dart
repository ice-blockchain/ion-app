import 'package:freezed_annotation/freezed_annotation.dart';

part 'dapp_data.freezed.dart';

@Freezed(copyWith: true)
class DAppData with _$DAppData {
  const factory DAppData({
    required String iconImage,
    required String title,
    required int identifier,
    @Default(false) bool isFavourite,
    @Default(false) bool isFeatured,
    @Default('') String? description,
    @Default('') String? fullDescription,
    @Default(0.0) double? value,
    @Default(false) bool isVerified,
    String? backgroundImage,
    String? link,
  }) = _DAppData;
}
