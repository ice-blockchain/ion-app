import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/model/video_data.dart';
import 'package:ice/app/features/feed/providers/trending_videos_provider.dart';

List<VideoData> trendingVideosDataSelector(WidgetRef ref) {
  return ref.watch(
    trendingVideosNotifierProvider.select(
      (AsyncValue<List<VideoData>> data) => data.value ?? <VideoData>[],
    ),
  );
}

bool trendingVideosIsLoadingSelector(WidgetRef ref) {
  return ref.watch(
    trendingVideosNotifierProvider.select(
      (AsyncValue<List<VideoData>> data) => data.isLoading,
    ),
  );
}
