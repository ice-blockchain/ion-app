import 'package:ice/app/features/feed/model/feed_category.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_current_category_provider.g.dart';

@riverpod
class FeedCurrentCategory extends _$FeedCurrentCategory {
  @override
  FeedCategory build() {
    return FeedCategory.feed;
  }

  set category(FeedCategory category) {
    state = category;
  }
}
