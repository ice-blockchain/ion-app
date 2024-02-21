import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/screen_side_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/explore_controls/components/filters_explore_controls_state.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/explore_controls/components/initial_explore_controls_state.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/explore_controls/hooks/use_explore_controls_state.dart';

class ExploreControls extends HookWidget {
  const ExploreControls({
    super.key,
    required this.pageScrollController,
  });

  final ScrollController pageScrollController;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<ExploreControlsState> state =
        useExploreControlsState(pageScrollController);

    return ScreenSideOffset.small(
      child: Padding(
        padding: EdgeInsets.only(top: 9.0.s),
        child: switch (state.value) {
          ExploreControlsState.initial => InitialExploreControlsState(
              onFiltersPressed: () {
                state.value = ExploreControlsState.filters;
              },
            ),
          ExploreControlsState.filters => const FiltersExploreControlsState(),
        },
      ),
    );
  }
}
