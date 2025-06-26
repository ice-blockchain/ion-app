// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/providers/networks_provider.r.dart';
import 'package:ion/app/features/wallets/views/pages/components/select_network_list_sheet.dart';
import 'package:ion/app/features/wallets/views/pages/receive_nft/providers/receive_nft_form_notifier.r.dart';
import 'package:ion/app/router/app_routes.gr.dart';

class SelectNftNetworkPage extends HookConsumerWidget {
  const SelectNftNetworkPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networks = ref.watch(networksWithNftProvider);
    return SelectNetworkListSheet(
      networks: networks,
      onNetworkSelected: (network) {
        ref.read(receiveNftFormNotifierProvider.notifier).setNetwork(network);
        ShareAddressToGetNftRoute().push<void>(context);
      },
    );
  }
}
