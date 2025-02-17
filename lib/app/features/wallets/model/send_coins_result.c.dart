// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_coins_result.c.freezed.dart';
part 'send_coins_result.c.g.dart';

@freezed
class SendCoinsResult with _$SendCoinsResult {
  const factory SendCoinsResult({
    required String txHash,
    required String status,
  }) = _SendCoinsResult;

  factory SendCoinsResult.fromJson(Map<String, dynamic> json) => _$SendCoinsResultFromJson(json);
}
