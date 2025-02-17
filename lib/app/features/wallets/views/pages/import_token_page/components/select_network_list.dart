// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class SelectNetworkList extends HookConsumerWidget {
  const SelectNetworkList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networks = useMemoized(() => Network.all);

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
          Expanded(
            child: ScreenSideOffset.small(
              child: ListView.separated(
                itemCount: networks.length,
                itemBuilder: (context, index) => _NetworkItem(
                  network: networks[index],
                ),
                separatorBuilder: (context, index) => SizedBox(height: 12.0.s),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkItem extends ConsumerWidget {
  const _NetworkItem({
    required this.network,
  });

  final Network network;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListItem(
      leading: network.svgIconAsset.icon(size: 36.0.s),
      title: Text(network.name),
      backgroundColor: context.theme.appColors.tertararyBackground,
      onTap: () => Navigator.of(context).pop(network),
    );
  }
}
