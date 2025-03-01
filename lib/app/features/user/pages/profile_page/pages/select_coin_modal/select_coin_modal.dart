// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/user/model/payment_type.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/select_coin_modal/providers/select_coin_search_provider.c.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/select_network_modal/select_network_modal.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/views/components/coins_list/coins_list_view.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

enum SelectCoinModalType {
  select,
  update,
}

class SelectCoinModal extends ConsumerWidget {
  const SelectCoinModal({
    required this.pubkey,
    required this.type,
    required this.paymentType,
    super.key,
  });

  final String pubkey;
  final SelectCoinModalType type;
  final PaymentType paymentType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinsResult = ref.watch(searchedWalletCoinsProvider);
    return SheetContent(
      body: CoinsListView(
        coinsResult: coinsResult,
        onItemTap: (CoinsGroup group) {
          switch (type) {
            case SelectCoinModalType.select:
              SelectNetworkRoute(
                paymentType: paymentType,
                pubkey: pubkey,
                coinAbbreviation: group.abbreviation,
                coinSymbolGroup: group.symbolGroup,
                selectNetworkModalType: SelectNetworkModalType.select,
              ).push<void>(context);
            case SelectCoinModalType.update:
              context.pop(group);
          }
        },
        title: context.i18n.common_select_coin,
        onQueryChanged: (query) {
          ref.read(selectCoinSearchQueryProvider.notifier).query = query;
        },
      ),
      backgroundColor: context.theme.appColors.secondaryBackground,
    );
  }
}
