import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/model/nft_layout_type.dart';
import 'package:ice/app/features/user/providers/user_preferences_selectors.dart';
import 'package:ice/app/features/wallet/model/nft_data.dart';

class NftPrice extends HookConsumerWidget {
  const NftPrice({
    super.key,
    required this.layoutType,
    required this.nftData,
  });

  final NftLayoutType layoutType;
  final NftData nftData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isBalanceVisible = isBalanceVisibleSelector(ref);
    final TextStyle textStyle = (layoutType == NftLayoutType.grid
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
      children: <Widget>[
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
