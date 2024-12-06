// SPDX-License-Identifier: ice License 1.0

import 'package:ion_identity_client/src/core/types/types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'simple_message_response.g.dart';

@JsonSerializable()
class SimpleMessageResponse {
  SimpleMessageResponse(
    this.message,
  );

  factory SimpleMessageResponse.fromJson(JsonObject json) {
    return _$SimpleMessageResponseFromJson(json);
  }

  final String message;

  JsonObject toJson() => _$SimpleMessageResponseToJson(this);
}
