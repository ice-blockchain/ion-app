import 'package:ice/app/features/feed/model/video_data.dart';
import 'package:ice/app/features/feed/providers/mock_data/videos_mock_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'trending_videos_provider.g.dart';

@Riverpod(keepAlive: true)
class TrendingVideosNotifier extends _$TrendingVideosNotifier {
  @override
  AsyncValue<List<VideoData>> build() {
    return AsyncData<List<VideoData>>(
      List<VideoData>.unmodifiable(<VideoData>[]),
    );
  }

  Future<void> fetch() async {
    state = const AsyncLoading<List<VideoData>>().copyWithPrevious(state);

    // to emulate loading state
    await Future<void>.delayed(const Duration(seconds: 1));

    state = AsyncData<List<VideoData>>(
      List<VideoData>.unmodifiable(mockedTrendingVideos),
    );
  }
}
