// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/dapps/views/components/favourite_icon/favorite_icon.dart';
import 'package:ice/generated/assets.gen.dart';

class Favourites extends StatelessWidget {
  const Favourites({
    super.key,
    this.onPress,
  });

  final VoidCallback? onPress;

  static double get containerHeight => 60.0.s;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20.0.s,
        ),
        child: GestureDetector(
          onTap: onPress,
          child: Container(
            height: containerHeight,
            width: double.infinity,
            padding: EdgeInsets.only(
              left: ScreenSideOffset.defaultSmallMargin,
              right: 10.0.s,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0.s),
              color: context.theme.appColors.tertararyBackground,
              border: Border.all(
                color: context.theme.appColors.onTerararyFill,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FavouriteIcon(
                  borderRadius: 12.0.s,
                  size: 36.0.s,
                ),
                SizedBox(width: 10.0.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.i18n.dapps_section_title_favourites,
                        style: context.theme.appTextThemes.body.copyWith(
                          color: context.theme.appColors.primaryText,
                        ),
                      ),
                      Text(
                        context.i18n.dapps_favourites_added(17),
                        style: context.theme.appTextThemes.caption3.copyWith(
                          color: context.theme.appColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                Assets.svg.iconArrowRight.icon(size: 26.0.s),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
