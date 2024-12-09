// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/constants/ui.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/wallet/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class NftHeaderSortAction extends ConsumerWidget {
  const NftHeaderSortAction({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nftSortingType = ref.watch(nftSortingTypeSelectorProvider);
    final color = context.theme.appColors.secondaryText;

    return TextButton(
      onPressed: () {
        NftsSortingRoute().go(context);
      },
      child: Padding(
        padding: EdgeInsets.all(UiConstants.hitSlop),
        child: Row(
          children: [
            Text(
              nftSortingType.getTitle(context),
              style: context.theme.appTextThemes.caption.copyWith(
                color: color,
              ),
            ),
            SizedBox(
              width: 5.0.s,
            ),
            Assets.svg.iconArrowDown.icon(size: 20.0.s, color: color),
          ],
        ),
      ),
    );
  }
}
