// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallet/views/pages/manage_coins/components/empty_state/empty_state.dart';
import 'package:ion/app/features/wallet/views/pages/manage_nfts/components/manage_nft_item/manage_nft_item.dart';
import 'package:ion/app/features/wallet/views/pages/manage_nfts/providers/manage_nfts_provider.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/components/navigation_app_bar/collapsing_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class ManageNftsPage extends HookConsumerWidget {
  const ManageNftsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchText = useState('');

    final filteredNftNetworksState = ref.watch(
      filteredNftsNetworkNotifierProvider(searchText: searchText.value),
    );

    useOnInit(
      () {
        ref
            .read(
              filteredNftsNetworkNotifierProvider(searchText: searchText.value)
                  .notifier,
            )
            .filter(searchText: searchText.value);
      },
      [searchText.value],
    );

    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: Text(context.i18n.wallet_manage_nfts),
            actions: [
              IconButton(
                icon: Assets.svg.iconSheetClose.icon(
                  size: NavigationAppBar.actionButtonSide,
                  color: context.theme.appColors.tertararyText,
                ),
                onPressed: context.pop,
              ),
            ],
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                CollapsingAppBar(
                  height: SearchInput.height,
                  child: ScreenSideOffset.small(
                    child: SearchInput(
                      onTextChanged: (String value) => searchText.value = value,
                      loading: filteredNftNetworksState.isLoading,
                    ),
                  ),
                ),
                filteredNftNetworksState.maybeWhen(
                  data: (filteredNftNetworks) {
                    if (filteredNftNetworks.isEmpty) {
                      return const EmptyState();
                    }
                    return SliverPadding(
                      padding: EdgeInsets.only(
                        bottom: 23.0.s + MediaQuery.paddingOf(context).bottom,
                      ),
                      sliver: SliverList.separated(
                        itemCount: filteredNftNetworks.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 12.0.s);
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return ScreenSideOffset.small(
                            child: ManageNftNetworkItem(
                              networkType: filteredNftNetworks
                                  .elementAt(index)
                                  .networkType,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => ListItemsLoadingState(
                    itemsCount: 7,
                    separatorHeight: 12.0.s,
                    listItemsLoadingStateType:
                        ListItemsLoadingStateType.scrollView,
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
