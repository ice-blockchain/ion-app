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
    return ScreenSideOffset.small(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const VideosIcon(),
          Padding(
            padding: EdgeInsets.only(left: 4.0.s),
            child: Text(
              'Trending Videos',
              style: context.theme.appTextThemes.subtitle
                  .copyWith(color: context.theme.appColors.primaryText),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: 24,
                height: 24,
                color: Colors.amber,
              ),
              Positioned(
                top: -12,
                left: -12,
                child: RotatedBox(
                  quarterTurns: 2,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    icon: ImageIcon(
                      AssetImage(
                        Assets.images.icons.iconBackArrow.path,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VideosIcon extends StatelessWidget {
  const VideosIcon({super.key});

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
