// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/core/types/types.dart';

part 'simple_message_response.f.freezed.dart';
part 'simple_message_response.f.g.dart';

@freezed
class SimpleMessageResponse with _$SimpleMessageResponse {
  const factory SimpleMessageResponse({
    required String message,
  }) = _SimpleMessageResponse;

  factory SimpleMessageResponse.fromJson(JsonObject json) => _$SimpleMessageResponseFromJson(json);
}
