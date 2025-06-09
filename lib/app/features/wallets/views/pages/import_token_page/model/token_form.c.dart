// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';

part 'token_form.c.freezed.dart';

@freezed
class TokenForm with _$TokenForm {
  const factory TokenForm({
    NetworkData? network,
    String? address,
    String? symbol,
    int? decimals,
  }) = _TokenForm;

  const TokenForm._();

  bool get canBeImported =>
      address != null && network != null && symbol != null && decimals != null && decimals! > 0;
}
