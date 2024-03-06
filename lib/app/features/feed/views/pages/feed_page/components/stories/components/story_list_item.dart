import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/stories/components/plus_icon.dart';
import 'package:ice/app/utils/image.dart';

class StoryListItem extends StatelessWidget {
  const StoryListItem({
    super.key,
    required this.imageUrl,
    required this.label,
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
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(19.5.s),
                  child: CachedNetworkImage(
                    width: width,
                    height: width,
                    imageUrl: getAdaptiveImageUrl(imageUrl, width),
                    fit: BoxFit.cover,
                  ),
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
