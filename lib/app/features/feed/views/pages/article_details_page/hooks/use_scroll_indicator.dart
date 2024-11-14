// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final indicatorWidthProvider = StateProvider<double>((ref) {
  final screenWidth = PlatformDispatcher.instance.views.first.physicalSize.width /
      PlatformDispatcher.instance.views.first.devicePixelRatio;
  return screenWidth * 0.05;
});

void useScrollIndicator(BuildContext context, ScrollController scrollController, WidgetRef ref) {
  useEffect(
    () {
      void onScroll() {
        if (!scrollController.hasClients) return;

        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.offset;
        final viewportWidth = MediaQuery.sizeOf(context).width;

        if (maxScroll == 0) {
          ref.read(indicatorWidthProvider.notifier).state = viewportWidth;
        } else {
          final scrollFraction = (currentScroll / maxScroll).clamp(0.0, 1.0);
          ref.read(indicatorWidthProvider.notifier).state =
              viewportWidth * (0.05 + (0.95 * scrollFraction));
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => onScroll());

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    },
    [scrollController],
  );
}
