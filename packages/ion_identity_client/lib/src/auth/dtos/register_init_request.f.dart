// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_init_request.f.freezed.dart';
part 'register_init_request.f.g.dart';

@freezed
class RegisterInitRequest with _$RegisterInitRequest {
  const factory RegisterInitRequest({
    required String email,
    String? earlyAccessEmail,
  }) = _RegisterInitRequest;

  factory RegisterInitRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterInitRequestFromJson(json);
}
