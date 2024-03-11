import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_filters/feed_filters.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/components/feed_navigation/feed_navigation.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/feed_controls/hooks/use_feed_controls_state.dart';

class FeedControls extends HookWidget {
  const FeedControls({
    super.key,
    required this.pageScrollController,
  });

  static double get height => 40.0.s;

  final ScrollController pageScrollController;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<FeedControlsState> state =
        useFeedControlsState(pageScrollController);

    return SizedBox(
      height: height,
      child: switch (state.value) {
        FeedControlsState.initial => FeedNavigation(
            onFiltersPressed: () {
              state.value = FeedControlsState.filters;
            },
          ),
        FeedControlsState.filters => const FeedFilters(),
      },
    );
  }
}
