import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum FeedControlsState { initial, filters }

ValueNotifier<FeedControlsState> useFeedControlsState(
  ScrollController pageScrollController,
) {
  final state = useState(FeedControlsState.initial);
  final previousOffset = useRef<double>(0);

  void updateStateOnScroll() {
    final currentOffset = pageScrollController.offset;
    if (currentOffset < previousOffset.value) {
      state.value = FeedControlsState.initial;
    }
    previousOffset.value = currentOffset;
  }

  useEffect(
    () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageScrollController.addListener(updateStateOnScroll);
      });
      return () {
        pageScrollController.removeListener(updateStateOnScroll);
      };
    },
    [],
  );

  return state;
}
