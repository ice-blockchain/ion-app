import 'package:ice/app/features/feed/model/feed_filter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_current_filter_provider.g.dart';

@riverpod
class FeedCurrentFilter extends _$FeedCurrentFilter {
  @override
  FeedFilter build() {
    return FeedFilter.forYou;
  }

  set filter(FeedFilter filter) {
    state = filter;
  }
}
