import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/model/nft_layout_type.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';
import 'package:ice/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.dart';

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
    final isBalanceVisible = isBalanceVisibleSelector(ref);
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
