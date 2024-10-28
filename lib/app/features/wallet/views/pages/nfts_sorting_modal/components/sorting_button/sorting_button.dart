// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/model/nft_sorting_type.dart';

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
          final identityKeyName = ref.read(currentIdentityKeyNameSelectorProvider) ?? '';
          ref
              .read(
                walletUserPreferencesNotifierProvider(identityKeyName: identityKeyName).notifier,
              )
              .setNftSortingType(sortingType);
        },
        label: Text(sortingType.getTitle(context)),
        mainAxisSize: MainAxisSize.max,
        type: ButtonType.secondary,
      ),
    );
  }
}
