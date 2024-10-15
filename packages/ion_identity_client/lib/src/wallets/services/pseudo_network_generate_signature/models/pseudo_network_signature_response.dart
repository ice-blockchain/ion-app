// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion_identity_client/src/wallets/models/requester.dart';

part 'pseudo_network_signature_response.freezed.dart';
part 'pseudo_network_signature_response.g.dart';

@freezed
class PseudoNetworkSignatureResponse with _$PseudoNetworkSignatureResponse {
  const factory PseudoNetworkSignatureResponse({
    required String id,
    required String walletId,
    required String network,
    required Requester requester,
    required Map<String, dynamic> requestBody,
    required String status,
    required Map<String, dynamic> signature,
    required DateTime dateRequested,
    required DateTime dateSigned,
  }) = _PseudoNetworkSignatureResponse;

  factory PseudoNetworkSignatureResponse.fromJson(Map<String, dynamic> json) =>
      _$PseudoNetworkSignatureResponseFromJson(json);
}
