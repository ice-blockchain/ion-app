// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'derive_response.f.freezed.dart';
part 'derive_response.f.g.dart';

@freezed
class DeriveResponse with _$DeriveResponse {
  factory DeriveResponse({
    required String output,
  }) = _DeriveResponse;

  factory DeriveResponse.fromJson(Map<String, dynamic> json) => _$DeriveResponseFromJson(json);
}
