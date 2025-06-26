// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/wallets/model/network_data.f.dart';

part 'receive_nft_form.f.freezed.dart';

@freezed
class ReceiveNftForm with _$ReceiveNftForm {
  const factory ReceiveNftForm({
    required NetworkData? selectedNetwork,
    required String? address,
  }) = _ReceiveNftForm;
}
