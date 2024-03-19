import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/model/nft_sorting_type.dart';
import 'package:ice/app/features/user/providers/user_preferences_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/tabs/constants.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class NftHeaderSortAction extends HookConsumerWidget {
  const NftHeaderSortAction({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final NftSortingType nftSortingType = nftSortingTypeSelector(ref);
    final Color color = context.theme.appColors.secondaryText;
    return TextButton(
      onPressed: () {
        IceRoutes.nftsSorting.go(context);
      },
      child: Padding(
        padding: EdgeInsets.all(Constants.hitSlop),
        child: Row(
          children: <Widget>[
            Text(
              nftSortingType.getTitle(context),
              style: context.theme.appTextThemes.caption.copyWith(
                color: color,
              ),
            ),
            SizedBox(
              width: 5.0.s,
            ),
            Assets.images.icons.iconArrowDown.icon(size: 20.0.s, color: color),
          ],
        ),
      ),
    );
  }
}
