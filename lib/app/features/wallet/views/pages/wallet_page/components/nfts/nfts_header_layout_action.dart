// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/wallet/model/nft_layout_type.dart';
import 'package:ice/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.dart';
import 'package:ice/app/features/wallet/providers/wallet_user_preferences/wallet_user_preferences_provider.dart';

class NftHeaderLayoutAction extends ConsumerWidget {
  const NftHeaderLayoutAction({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nftLayoutType = ref.watch(nftLayoutTypeSelectorProvider);
    final activeColor = context.theme.appColors.primaryText;
    final inactiveColor = context.theme.appColors.tertararyText;

    return Row(
      children: [
        TextButton(
          onPressed: () {
            final userId = ref.read(currentUserIdSelectorProvider);
            ref
                .read(walletUserPreferencesNotifierProvider(userId: userId).notifier)
                .setNftLayoutType(NftLayoutType.grid);
          },
          child: Padding(
            padding: EdgeInsets.only(
              top: UiConstants.hitSlop,
              left: UiConstants.hitSlop,
              right: 7.0.s,
              bottom: UiConstants.hitSlop,
            ),
            child: NftLayoutType.grid.iconAsset.icon(
              color: NftLayoutType.grid == nftLayoutType ? activeColor : inactiveColor,
              size: 20.0.s,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            final userId = ref.read(currentUserIdSelectorProvider);
            ref
                .read(walletUserPreferencesNotifierProvider(userId: userId).notifier)
                .setNftLayoutType(NftLayoutType.list);
          },
          child: Padding(
            padding: EdgeInsets.only(
              top: UiConstants.hitSlop,
              right: UiConstants.hitSlop,
              left: 7.0.s,
              bottom: UiConstants.hitSlop,
            ),
            child: NftLayoutType.list.iconAsset.icon(
              color: NftLayoutType.list == nftLayoutType ? activeColor : inactiveColor,
              size: 20.0.s,
            ),
          ),
        ),
      ],
    );
  }
}
