// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/section_header/section_header.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/feed/providers/trending_videos_overlay_provider.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_skeleton.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/video_icon.dart';

class TrendingVideos extends HookConsumerWidget {
  const TrendingVideos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState(true);
    useEffect(
      () {
        final timer = Timer(const Duration(seconds: 3), () => loading.value = false);
        return timer.cancel;
      },
      <Object?>[],
    );
    final listOverlay = ref.watch(trendingVideosOverlayNotifierProvider);
    return Padding(
      padding: EdgeInsets.only(bottom: 18.0.s),
      child: Column(
        children: [
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
