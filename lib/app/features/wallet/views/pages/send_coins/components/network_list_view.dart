import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/components/network_item.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class NetworkListView extends IceSimplePage {
  const NetworkListView(super.route, super.payload);

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.s),
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
              height: 12.0.s,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return ScreenSideOffset.small(
              child: NetworkItem(
                networkType: networkTypeValues[index],
                onTap: () {
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
