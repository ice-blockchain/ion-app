import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class TrendingVideos extends StatelessWidget {
  const TrendingVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: <Widget>[_Header()]);
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      only: ScreenOffsetSide.left,
      child: SizedBox(
        height: 46.0.s,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                const _VideosIcon(),
                Padding(
                  padding: EdgeInsets.only(left: 4.0.s),
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
                right: ScreenSideOffset.defaultSmallMargin -
                    _ForwardButton.hitSlop,
              ),
              child: const _ForwardButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideosIcon extends StatelessWidget {
  const _VideosIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.0.s,
      height: 29.0.s,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.images.bg.iconStroke.path),
          fit: BoxFit.cover,
        ),
      ),
      child: ImageIcon(
        AssetImage(Assets.images.icons.iconVideosTrading.path),
        color: context.theme.appColors.secondaryBackground,
        size: 20.0.s,
      ),
    );
  }
}

class _ForwardButton extends StatelessWidget {
  const _ForwardButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: totalSize,
      height: totalSize,
      child: RotatedBox(
        quarterTurns: 2,
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          icon: ImageIcon(
            AssetImage(
              Assets.images.icons.iconBackArrow.path,
            ),
            size: iconSize,
          ),
        ),
      ),
    );
  }

  static double get hitSlop => 10.0.s;
  static double get iconSize => 24.0.s;
  static double get totalSize => iconSize + hitSlop * 2;
}
