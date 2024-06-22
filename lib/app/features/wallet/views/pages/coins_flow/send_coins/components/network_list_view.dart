import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/components/network_item.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/providers/send_coins_form_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class NetworkListView extends IceSimplePage {
  const NetworkListView(super.route, super.payload, {super.key});

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, void payload) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: UiSize.xxSmall),
          child: NavigationAppBar.screen(
            title: context.i18n.wallet_choose_network,
            actions: const <Widget>[
              NavigationCloseButton(),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: networkTypeValues.length,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: UiSize.small,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return ScreenSideOffset.small(
              child: NetworkItem(
                networkType: networkTypeValues[index],
                onTap: () {
                  ref
                      .read(sendCoinsFormControllerProvider.notifier)
                      .selectNetwork(networkTypeValues[index]);

                  IceRoutes.coinSendForm.push(
                    context,
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
