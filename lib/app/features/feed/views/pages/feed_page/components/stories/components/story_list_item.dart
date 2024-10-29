// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/plus_icon.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/stories/components/story_colored_border.dart';
import 'package:ion/app/router/app_routes.dart';

class StoryListItem extends HookWidget {
  const StoryListItem({
    required this.imageUrl,
    required this.label,
    super.key,
    this.nft = false,
    this.me = false,
    this.gradient,
  });

  final String imageUrl;
  final String label;
  final bool nft;
  final bool me;
  final Gradient? gradient;

  static double get width => 65.0.s;

  static double get height => 91.0.s;

  static double get plusSize => 18.0.s;

  static double get borderSize => 2.0.s;

  @override
  Widget build(BuildContext context) {
    final viewed = useState(!me && Random().nextBool());

    return GestureDetector(
      onTap: () {
        if (!me) viewed.value = true;
        StoryViewerRoute().push<void>(context);
      },
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                StoryColoredBorder(
                  hexagon: nft,
                  size: width,
                  color: context.theme.appColors.strokeElements,
                  gradient: viewed.value ? null : gradient,
                  child: StoryColoredBorder(
                    hexagon: nft,
                    size: width - borderSize * 2,
                    color: context.theme.appColors.secondaryBackground,
                    child: Avatar(
                      size: width - borderSize * 4,
                      imageUrl: imageUrl,
                      hexagon: nft,
                    ),
                  ),
                ),
                if (me)
                  Positioned(
                    bottom: -plusSize / 2,
                    child: PlusIcon(
                      size: plusSize,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0.s),
              child: Text(
                label,
                style: context.theme.appTextThemes.caption3.copyWith(
                  color: context.theme.appColors.primaryText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
