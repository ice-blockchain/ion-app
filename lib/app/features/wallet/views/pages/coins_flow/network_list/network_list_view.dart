import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/network_list/network_item.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/providers/send_coins_form_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

enum NetworkListViewType {
  send,
  receive,
}

class NetworkListView extends HookConsumerWidget {
  const NetworkListView({this.type = NetworkListViewType.send, super.key});

  final NetworkListViewType? type;

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.s),
            child: NavigationAppBar.screen(
              title: Text(context.i18n.wallet_choose_network),
              actions: const [
                NavigationCloseButton(),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: networkTypeValues.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 12.0.s,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return ScreenSideOffset.small(
                child: NetworkItem(
                  networkType: networkTypeValues[index],
                  onTap: () {
                    if (type == NetworkListViewType.send) {
                      ref
                          .read(sendCoinsFormControllerProvider.notifier)
                          .selectNetwork(networkTypeValues[index]);
                      CoinsSendFormRoute().push<void>(context);
                    } else {
                      ref
                          .read(receiveCoinsFormControllerProvider.notifier)
                          .selectNetwork(networkTypeValues[index]);
                      ShareAddressRoute().go(context);
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
