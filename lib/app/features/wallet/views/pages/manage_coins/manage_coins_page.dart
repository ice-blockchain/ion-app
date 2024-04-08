import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/wallet/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ice/app/features/wallet/views/pages/manage_coins/components/empty_state/empty_state.dart';
import 'package:ice/app/features/wallet/views/pages/manage_coins/components/manage_coin_item/manage_coin_item.dart';
import 'package:ice/app/features/wallet/views/pages/manage_coins/model/manage_coin_data.dart';
import 'package:ice/app/features/wallet/views/pages/manage_coins/providers/manage_coins_provider.dart';
import 'package:ice/app/features/wallet/views/pages/manage_coins/providers/selectors/manage_coins_selectors.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/router/components/floating_app_bar/floating_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_done_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class ManageCoinsPage extends IceSimplePage {
  const ManageCoinsPage(super._route, super.payload);

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final ValueNotifier<String> searchText = useState('');

    final List<ManageCoinData> manageCoinsData = manageCoinsDataSelector(ref);
    final bool isLoading = manageCoinsIsLoadingSelector(ref);

    useOnInit(
      () {
        ref
            .read(manageCoinsNotifierProvider.notifier)
            .fetch(searchValue: searchText.value);
      },
      <Object?>[searchText.value],
    );

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        children: <Widget>[
          NavigationAppBar.modal(
            showBackButton: false,
            title: context.i18n.wallet_manage_coins,
            actions: const <Widget>[NavigationDoneButton()],
          ),
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                FloatingAppBar(
                  height: SearchInput.height,
                  child: ScreenSideOffset.small(
                    child: SearchInput(
                      onTextChanged: (String value) => searchText.value = value,
                      loading: isLoading && manageCoinsData.isNotEmpty,
                    ),
                  ),
                ),
                if (manageCoinsData.isEmpty && !isLoading) const EmptyState(),
                if (manageCoinsData.isEmpty && isLoading)
                  const ListItemsLoadingState(),
                if (manageCoinsData.isNotEmpty)
                  SliverPadding(
                    padding: EdgeInsets.only(
                      bottom: 23.0.s + MediaQuery.paddingOf(context).bottom,
                    ),
                    sliver: SliverList.separated(
                      itemCount: manageCoinsData.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 12.0.s,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return ScreenSideOffset.small(
                          child: ManageCoinItem(
                            manageCoinData: manageCoinsData[index],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
