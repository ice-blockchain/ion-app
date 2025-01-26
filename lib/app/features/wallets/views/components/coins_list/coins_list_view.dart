// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/coins_group.c.dart';
import 'package:ion/app/features/wallets/providers/filtered_wallet_coins_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/coins_list/coin_item.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';

class CoinsListView extends ConsumerWidget {
  const CoinsListView({
    required this.onItemTap,
    required this.title,
    this.showBackButton = false,
    super.key,
  });

  final void Function(CoinsGroup group) onItemTap;
  final String title;
  final bool showBackButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinsResult = ref.watch(filteredWalletCoinsProvider);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.s),
          child: NavigationAppBar.screen(
            title: Text(title),
            showBackButton: showBackButton,
            actions: const [
              NavigationCloseButton(),
            ],
          ),
        ),
        ScreenSideOffset.small(
          child: SearchInput(
            onTextChanged: (String value) {},
          ),
        ),
        SizedBox(
          height: 12.0.s,
        ),
        Expanded(
          child: coinsResult.maybeWhen(
            data: (groups) {
              if (groups.isEmpty) {
                return ListItemsLoadingState(
                  itemsCount: 11,
                  itemHeight: 60.0.s,
                  listItemsLoadingStateType: ListItemsLoadingStateType.listView,
                );
              }
              return ListView.separated(
                itemCount: groups.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 12.0.s,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return ScreenSideOffset.small(
                    child: CoinsGroupItem(
                      coinsGroup: groups[index],
                      onTap: () => onItemTap(groups[index]),
                    ),
                  );
                },
              );
            },
            orElse: () => ListItemsLoadingState(
              itemsCount: 11,
              itemHeight: 60.0.s,
              listItemsLoadingStateType: ListItemsLoadingStateType.listView,
            ),
          ),
        ),
      ],
    );
  }
}
