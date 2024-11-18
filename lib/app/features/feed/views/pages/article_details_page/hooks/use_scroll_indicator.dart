import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

double useScrollIndicator(ScrollController scrollController) {
  final progress = useState<double>(0);

  useEffect(
    () {
      void calculateProgress() {
        if (!scrollController.hasClients) return;

        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.offset;

        if (maxScroll > 0) {
          final scrollFraction = (currentScroll / maxScroll).clamp(0.0, 1.0);
          progress.value = 0.05 + (0.95 * scrollFraction);
        } else {
          progress.value = 1.0;
        }
      }

      void onInitialFrame() {
        if (scrollController.hasClients && scrollController.position.maxScrollExtent > 0) {
          calculateProgress();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) => onInitialFrame());
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => onInitialFrame());

      scrollController.addListener(calculateProgress);
      return () => scrollController.removeListener(calculateProgress);
    },
    [scrollController],
  );

  return progress.value;
}
