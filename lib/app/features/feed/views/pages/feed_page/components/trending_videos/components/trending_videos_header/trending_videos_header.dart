import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_header/forward_button.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_header/video_icon.dart';

class TrendingVideosHeader extends StatelessWidget {
  const TrendingVideosHeader();

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      only: ScreenOffsetSide.left,
      child: SizedBox(
        height: 47.0.s,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                const VideosIcon(),
                Padding(
                  padding: EdgeInsets.only(left: 2.0.s),
                  child: Text(
                    context.i18n.trending_videos,
                    style: context.theme.appTextThemes.subtitle
                        .copyWith(color: context.theme.appColors.primaryText),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                right:
                    ScreenSideOffset.defaultSmallMargin - ForwardButton.hitSlop,
              ),
              child: const ForwardButton(),
            ),
          ],
        ),
      ),
    );
  }
}
