// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_action_signing_init_request.c.freezed.dart';
part 'user_action_signing_init_request.c.g.dart';

@freezed
class UserActionSigningInitRequest with _$UserActionSigningInitRequest {
  const factory UserActionSigningInitRequest({
    required String userActionPayload,
    required String userActionHttpMethod,
    required String userActionHttpPath,
    @Default('Api') String userActionServerKind,
  }) = _UserActionSigningInitRequest;

  factory UserActionSigningInitRequest.fromJson(Map<String, dynamic> json) =>
      _$UserActionSigningInitRequestFromJson(json);
}
