// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/model/nft_data.dart';
import 'package:ion/app/features/wallet/model/nft_layout_type.dart';

class NftPrice extends ConsumerWidget {
  const NftPrice({
    required this.layoutType,
    required this.nftData,
    super.key,
  });

  final NftLayoutType layoutType;
  final NftData nftData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBalanceVisible = ref.watch(isBalanceVisibleSelectorProvider);
    final textStyle = (layoutType == NftLayoutType.grid
            ? context.theme.appTextThemes.caption
            : context.theme.appTextThemes.caption3)
        .copyWith(
      color: context.theme.appColors.quaternaryText,
    );

    if (!isBalanceVisible) {
      return Text(
        '******',
        style: textStyle,
      );
    }

    return Row(
      children: [
        Avatar(
          size: 12.0.s,
          imageUrl: nftData.currencyIconUrl,
        ),
        SizedBox(
          width: 5.0.s,
        ),
        Text(
          '${nftData.price} ${nftData.currency}',
          style: textStyle,
        ),
      ],
    );
  }
}
