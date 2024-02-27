import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum FeedControlsState { initial, filters }

ValueNotifier<FeedControlsState> useFeedControlsState(
  ScrollController pageScrollController,
) {
  final ValueNotifier<FeedControlsState> state =
      useState(FeedControlsState.initial);

  useEffect(
    () {
      void isScrollingNotifierListener() {
        if (pageScrollController.position.isScrollingNotifier.value) {
          state.value = FeedControlsState.initial;
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageScrollController.position.isScrollingNotifier
            .addListener(isScrollingNotifierListener);
      });
      return () {
        pageScrollController.position.isScrollingNotifier
            .removeListener(isScrollingNotifierListener);
      };
    },
    <Object?>[pageScrollController],
  );

  return state;
}
