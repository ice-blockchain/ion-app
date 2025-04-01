// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/providers/filtered_assets_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/coins_list/coins_list_view.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class SelectCoinModalPage extends ConsumerWidget {
  const SelectCoinModalPage({
    required this.onCoinSelected,
    super.key,
  });

  final ValueChanged<CoinsGroup> onCoinSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinsResult = ref.watch(filteredCoinsNotifierProvider);

    return SheetContent(
      body: CoinsListView(
        coinsResult: coinsResult,
        onItemTap: onCoinSelected,
        title: context.i18n.wallet_send_coins,
        onQueryChanged: (String query) {
          ref.read(filteredCoinsNotifierProvider.notifier).search(query);
        },
      ),
    );
  }
}
