// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/wallet/model/nft_sorting_type.dart';
import 'package:ice/app/features/wallet/providers/wallet_user_preferences/wallet_user_preferences_provider.dart';

class SortingButton extends ConsumerWidget {
  const SortingButton({
    required this.sortingType,
    super.key,
  });

  final NftSortingType sortingType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenSideOffset.small(
      child: Button(
        leadingIcon: sortingType.iconAsset.icon(
          color: context.theme.appColors.primaryAccent,
        ),
        onPressed: () {
          final userId = ref.read(currentUserIdSelectorProvider);
          ref
              .read(walletUserPreferencesNotifierProvider(userId: userId).notifier)
              .setNftSortingType(sortingType);
        },
        label: Text(sortingType.getTitle(context)),
        mainAxisSize: MainAxisSize.max,
        type: ButtonType.secondary,
      ),
    );
  }
}
