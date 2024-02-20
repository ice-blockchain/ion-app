import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/mock.dart';
import 'package:ice/app/utils/num.dart';
import 'package:ice/generated/assets.gen.dart';

class TrendingVideosList extends StatelessWidget {
  const TrendingVideosList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.0.s,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSideOffset.defaultSmallMargin,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: trendingVideos.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 12.0.s);
        },
        itemBuilder: (BuildContext context, int index) {
          return _TrendingVideoListItem(
            video: trendingVideos[index],
          );
        },
      ),
    );
  }
}

class _TrendingVideoListItem extends StatelessWidget {
  const _TrendingVideoListItem({
    required this.video,
  });

  final TrendingVideo video;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 240.0.s,
        height: 160.0.s,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0.s),
          image: DecorationImage(
            image: CachedNetworkImageProvider(video.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              height: 40.0.s,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12.0.s),
                    ),
                    onPressed: () {},
                    child: Row(
                      children: <Widget>[
                        ImageIcon(
                          AssetImage(Assets.images.icons.iconVideoLikeOn.path),
                          size: 14.0.s,
                          color: context.theme.appColors.secondaryBackground,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 2.0.s),
                          child: Text(
                            formatDoubleCompact(video.likes),
                            style:
                                context.theme.appTextThemes.caption3.copyWith(
                              color:
                                  context.theme.appColors.secondaryBackground,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 40.0.s,
                    child: IconButton(
                      onPressed: () {},
                      icon: ImageIcon(
                        AssetImage(Assets.images.icons.iconMorePopup.path),
                        size: 16.0.s,
                        color: context.theme.appColors.secondaryBackground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0.s),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 20.0.s,
                    height: 20.0.s,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          video.authorImageUrl,
                        ),
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.theme.appColors.secondaryBackground,
                        width: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 4.0.s),
                      child: Text(
                        video.authorName,
                        overflow: TextOverflow.ellipsis,
                        style: context.theme.appTextThemes.caption3.copyWith(
                          color: context.theme.appColors.secondaryBackground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
