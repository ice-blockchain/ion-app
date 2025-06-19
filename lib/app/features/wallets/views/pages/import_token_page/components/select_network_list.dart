// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/providers/networks_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/components/select_network_list_sheet.dart';

class SelectNetworkList extends HookConsumerWidget {
  const SelectNetworkList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networks = ref.watch(networksProvider);
    return SelectNetworkListSheet(
      networks: networks,
      onNetworkSelected: (network) => Navigator.of(context).pop(network),
    );
  }
}
