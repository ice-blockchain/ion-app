// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/components/empty_state/empty_state.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/components/manage_coin_item/manage_coin_item.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/providers/manage_coins_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/components/navigation_app_bar/collapsing_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_text_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class ManageCoinsPage extends HookConsumerWidget {
  const ManageCoinsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = useState('');

    final filteredCoinsState = ref.watch(
      filteredCoinsNotifierProvider(searchText: searchText.value),
    );

    useOnInit(
      () {
        final notifier = filteredCoinsNotifierProvider(searchText: searchText.value).notifier;
        ref.read(notifier).filter(searchText: searchText.value);
      },
      [searchText.value],
    );

    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.wallet_manage_coins),
            actions: [NavigationTextButton(label: context.i18n.core_done)],
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                CollapsingAppBar(
                  height: SearchInput.height,
                  child: ScreenSideOffset.small(
                    child: SearchInput(
                      onTextChanged: (String value) => searchText.value = value,
                      loading: filteredCoinsState.isLoading,
                    ),
                  ),
                ),
                filteredCoinsState.maybeWhen(
                  data: (filteredCoins) {
                    if (filteredCoins.isEmpty) {
                      return const EmptyState();
                    }
                    return SliverPadding(
                      padding: EdgeInsets.only(
                        bottom: ScreenBottomOffset.defaultMargin,
                      ),
                      sliver: SliverList.separated(
                        itemCount: filteredCoins.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.0.s),
                        itemBuilder: (BuildContext context, int index) {
                          return ScreenSideOffset.small(
                            child: ManageCoinItem(
                              coinId: filteredCoins[index].coinInWallet.coin.abbreviation,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => ListItemsLoadingState(
                    itemsCount: 7,
                    separatorHeight: 12.0.s,
                    listItemsLoadingStateType: ListItemsLoadingStateType.scrollView,
                  ),
                  orElse: () => const EmptyState(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
