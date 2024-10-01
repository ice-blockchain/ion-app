// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/model/dapp_data.dart';
import 'package:ice/app/features/dapps/views/components/favourite_icon/favorite_icon.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/utils/num.dart';
import 'package:ice/generated/assets.gen.dart';

class GridItem extends HookWidget {
  const GridItem({
    required this.dAppData,
    super.key,
    this.showIsFavourite = false,
    this.showTips = true,
  });
  final DAppData dAppData;
  final bool showIsFavourite;
  final bool showTips;

  @override
  Widget build(BuildContext context) {
    final isFavourite = useState(dAppData.isFavourite);
    return InkWell(
      onTap: () => DAppDetailsRoute(dappId: dAppData.identifier).push<void>(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 48.0.s,
            height: 48.0.s,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0.s),
            ),
            child: Image.asset(
              dAppData.iconImage,
              width: 48.0.s,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 10.0.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      dAppData.title,
                      style: context.theme.appTextThemes.body.copyWith(
                        color: context.theme.appColors.primaryText,
                      ),
                    ),
                    if (dAppData.isVerified)
                      Padding(
                        padding: EdgeInsets.only(left: 4.0.s),
                        child: IconTheme(
                          data: IconThemeData(
                            size: 16.0.s,
                            color: context.theme.appColors.onTertararyBackground,
                          ),
                          child: Assets.svg.iconBadgeVerify.icon(size: 16.0.s),
                        ),
                      ),
                  ],
                ),
                Text(
                  dAppData.description ?? '',
                  style: context.theme.appTextThemes.caption3.copyWith(
                    color: context.theme.appColors.secondaryText,
                  ),
                ),
                if (showTips)
                  Row(
                    children: [
                      IconTheme(
                        data: IconThemeData(
                          size: 12.0.s,
                          color: context.theme.appColors.onTertararyBackground,
                        ),
                        child: Assets.svg.iconButtonIceStroke.icon(size: 12.0.s),
                      ),
                      if (dAppData.value != null)
                        Padding(
                          padding: EdgeInsets.only(left: 3.0.s),
                          child: Text(
                            formatDouble(dAppData.value!),
                            style: context.theme.appTextThemes.caption3.copyWith(
                              color: context.theme.appColors.tertararyText,
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          if (showIsFavourite)
            FavouriteIcon(
              isFavourite: isFavourite.value,
              onTap: () {
                isFavourite.value = !isFavourite.value;
              },
            ),
        ],
      ),
    );
  }
}
