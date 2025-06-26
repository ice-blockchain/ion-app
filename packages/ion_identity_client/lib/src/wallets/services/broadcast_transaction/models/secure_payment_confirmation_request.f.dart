// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'secure_payment_confirmation_request.f.freezed.dart';
part 'secure_payment_confirmation_request.f.g.dart';

@freezed
class SecurePaymentConfirmationRequest with _$SecurePaymentConfirmationRequest {
  const factory SecurePaymentConfirmationRequest({
    required String kind,
    required String transaction,
    @JsonKey(includeIfNull: false) String? authorization,
  }) = _SecurePaymentConfirmationRequest;

  factory SecurePaymentConfirmationRequest.fromJson(Map<String, dynamic> json) =>
      _$SecurePaymentConfirmationRequestFromJson(json);
}
