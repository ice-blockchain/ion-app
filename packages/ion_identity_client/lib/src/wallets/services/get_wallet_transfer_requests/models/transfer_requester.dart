// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_requester.freezed.dart';
part 'transfer_requester.g.dart';

@freezed
class TransferRequester with _$TransferRequester {
  const factory TransferRequester({
    required String userId,
    required String tokenId,
    required String appId,
  }) = _TransferRequester;

  factory TransferRequester.fromJson(Map<String, dynamic> json) =>
      _$TransferRequesterFromJson(json);
}
