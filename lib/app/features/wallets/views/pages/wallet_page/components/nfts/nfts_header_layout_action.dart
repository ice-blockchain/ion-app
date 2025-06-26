// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/constants/ui.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/wallets/model/nft_layout_type.dart';
import 'package:ion/app/features/wallets/providers/wallet_user_preferences/user_preferences_selectors.r.dart';
import 'package:ion/app/features/wallets/providers/wallet_user_preferences/wallet_user_preferences_provider.r.dart';

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
            final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
            ref
                .read(
                  walletUserPreferencesNotifierProvider(identityKeyName: identityKeyName).notifier,
                )
                .setNftLayoutType(NftLayoutType.grid);
          },
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              top: UiConstants.hitSlop,
              start: UiConstants.hitSlop,
              end: 7.0.s,
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
            final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
            ref
                .read(
                  walletUserPreferencesNotifierProvider(identityKeyName: identityKeyName).notifier,
                )
                .setNftLayoutType(NftLayoutType.list);
          },
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              top: UiConstants.hitSlop,
              start: UiConstants.hitSlop,
              end: 7.0.s,
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
