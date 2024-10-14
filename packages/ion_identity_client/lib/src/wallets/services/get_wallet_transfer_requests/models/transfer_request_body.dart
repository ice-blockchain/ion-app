// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_request_body.freezed.dart';
part 'transfer_request_body.g.dart';

@freezed
class TransferRequestBody with _$TransferRequestBody {
  const factory TransferRequestBody.native({
    required String kind,
    required String to,
    required String amount,
  }) = NativeTransferRequestBody;

  const factory TransferRequestBody.erc721({
    required String kind,
    required String contract,
    required String to,
    required String tokenId,
  }) = Erc721TransferRequestBody;

  factory TransferRequestBody.fromJson(Map<String, dynamic> json) =>
      _$TransferRequestBodyFromJson(json);
}
