import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/section_header/section_header.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/model/trending_videos_overlay.dart';
import 'package:ice/app/features/feed/providers/trending_videos_overlay_provider.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_skeleton.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/video_icon.dart';

class TrendingVideos extends HookConsumerWidget {
  const TrendingVideos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<bool> loading = useState(true);
    useEffect(
      () {
        Timer(const Duration(seconds: 3), () => loading.value = false);
        return null;
      },
      <Object?>[],
    );
    final TrendingVideosOverlay listOverlay =
        ref.watch(trendingVideosOverlayNotifierProvider);
    return Padding(
      padding: EdgeInsets.only(bottom: 18.0.s),
      child: Column(
        children: <Widget>[
          SectionHeader(
            onPress: () {},
            title: context.i18n.feed_trending_videos,
            leadingIcon: const VideosIcon(),
          ),
          if (loading.value)
            TrendingVideosListSkeleton(listOverlay: listOverlay)
          else
            TrendingVideosList(listOverlay: listOverlay),
        ],
      ),
    );
  }
}
