import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_header.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list.dart';

class TrendingVideos extends StatelessWidget {
  const TrendingVideos({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 18.0.s),
      child: const Column(
        children: <Widget>[
          TrendingVideosHeader(),
          TrendingVideosList(
            listOverlay: TrendingVideosListOverlay.horizontal,
          ),
        ],
      ),
    );
  }
}
