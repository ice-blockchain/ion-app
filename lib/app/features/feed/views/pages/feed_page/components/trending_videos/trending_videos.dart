import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/section_header/section_header.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/model/trending_videos_overlay.dart';
import 'package:ice/app/features/feed/providers/selectors/trending_videos_selectors.dart';
import 'package:ice/app/features/feed/providers/trending_videos_provider.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_videos_list_skeleton.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/trending_videos/components/video_icon.dart';
import 'package:ice/app/hooks/use_on_init.dart';

class TrendingVideos extends HookConsumerWidget {
  const TrendingVideos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingVideos = trendingVideosDataSelector(ref);
    final isLoading = trendingVideosIsLoadingSelector(ref);

    useOnInit<void>(
      () {
        ref.read(trendingVideosNotifierProvider.notifier).fetch();
      },
      <Object?>[],
    );

    if (trendingVideos.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 18.0.s),
      child: Column(
        children: [
          SectionHeader(
            onPress: () {},
            title: context.i18n.feed_trending_videos,
            leadingIcon: const VideosIcon(),
          ),
          if (isLoading)
            TrendingVideosListSkeleton(listOverlay: TrendingVideosOverlay.vertical)
          else
            TrendingVideosList(trendingVideos: trendingVideos),
        ],
      ),
    );
  }
}
