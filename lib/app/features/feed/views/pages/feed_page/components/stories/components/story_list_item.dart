import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/components/plus_icon.dart';

class StoryListItem extends StatelessWidget {
  const StoryListItem({
    required this.imageUrl,
    required this.label,
    super.key,
    this.showPlus = false,
  });

  final String imageUrl;
  final String label;
  final bool showPlus;

  static double get width => 65.0.s;

  static double get height => 91.0.s;

  static double get plusSize => 18.0.s;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
                Avatar(
                  size: width,
                  imageUrl: imageUrl,
                  borderRadius: BorderRadius.circular(19.5.s),
                ),
                if (showPlus)
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
