import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum FeedControlsState { initial, filters }

ValueNotifier<FeedControlsState> useFeedControlsState(
  ScrollController pageScrollController,
) {
  final state = useState(FeedControlsState.initial);
  final previousOffset = useRef<double>(0);

  useEffect(
    () {
      void scrollListener() {
        final currentOffset = pageScrollController.offset;
        if (currentOffset < previousOffset.value) {
          state.value = FeedControlsState.initial;
        }
        previousOffset.value = currentOffset;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageScrollController.addListener(scrollListener);
      });
      return () {
        pageScrollController.removeListener(scrollListener);
      };
    },
    <Object?>[pageScrollController],
  );

  return state;
}
