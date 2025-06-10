// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/data/models/network_data.c.dart';
import 'package:ion/generated/assets.gen.dart';

part 'network_selector_data.c.freezed.dart';

@freezed
class NetworkSelectorData with _$NetworkSelectorData {
  const factory NetworkSelectorData({
    required SelectedNetworkItem selected,
    required List<SelectedNetworkItem> items,
  }) = _NetworkSelectorData;
}

@freezed
sealed class SelectedNetworkItem with _$SelectedNetworkItem {
  const SelectedNetworkItem._();

  const factory SelectedNetworkItem.network({
    required NetworkData network,
  }) = _SelectedNetwork;

  const factory SelectedNetworkItem.all({
    required List<NetworkData> networks,
  }) = _AllNetworks;

  String get image {
    return when(
      network: (network) => network.image,
      all: (_) => Assets.svg.networks.walletInfinite,
    );
  }

  String getDisplayName(BuildContext context) {
    return when(
      network: (network) => network.displayName,
      all: (_) => context.i18n.core_all,
    );
  }
}
