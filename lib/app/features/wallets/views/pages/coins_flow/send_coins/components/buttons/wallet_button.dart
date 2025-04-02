// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class WalletButton extends ConsumerWidget {
  const WalletButton({
    required this.walletId,
    this.onTap,
    super.key,
  });

  final String walletId;
  final VoidCallback? onTap;

  static double get itemHeight => 58.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletDataResult = ref.watch(walletViewByIdProvider(id: walletId));

    return walletDataResult.maybeWhen(
      data: (walletData) {
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: context.theme.appColors.strokeElements),
            borderRadius: BorderRadius.circular(16.0.s),
            color: context.theme.appColors.secondaryBackground,
          ),
          child: ListItem(
            onTap: onTap,
            title: Text(walletData.name),
            // TODO: (1) address is not implemented!
            // subtitle: Text(walletData.address ?? ''),
            subtitle: const Text(''),
            leading: Avatar(
              size: 36.0.s,
              // TODO: (1) What should be shown here?
              imageUrl: '',
              borderRadius: BorderRadius.circular(10.0.s),
            ),
            border: Border.all(
              color: context.theme.appColors.strokeElements,
            ),
            constraints: BoxConstraints(minHeight: itemHeight),
            contentPadding: EdgeInsetsDirectional.only(
              start: 12.0.s,
              end: 8.0.s,
            ),
            backgroundColor: Colors.transparent,
            trailing: Padding(
              padding: EdgeInsets.all(8.0.s),
              child: onTap != null ? Assets.svg.iconArrowDown.icon() : null,
            ),
          ),
        );
      },
      orElse: () => ItemLoadingState(
        itemHeight: itemHeight,
      ),
    );
  }
}
