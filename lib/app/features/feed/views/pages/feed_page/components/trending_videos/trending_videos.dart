import 'package:flutter/material.dart';
import 'package:ice/app/components/section_header/section_header.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list/trending_videos_list.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/video_icon/video_icon.dart';

class TrendingVideos extends StatelessWidget {
  const TrendingVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.0.s),
      child: Column(
        children: <Widget>[
          SectionHeader(
            onPress: () {},
            title: context.i18n.trending_videos,
            leadingIcon: const VideosIcon(),
          ),
          const TrendingVideosList(
            listOverlay: TrendingVideosListOverlay.vertical,
          ),
        ],
      ),
    );
  }
}
