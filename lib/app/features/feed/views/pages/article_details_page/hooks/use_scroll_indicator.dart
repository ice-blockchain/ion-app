// SPDX-License-Identifier: ice License 1.0

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

double useScrollIndicator(ScrollController scrollController) {
  final progress = useState<double>(0);

  useEffect(
    () {
      void onScroll() {
        if (!scrollController.hasClients) return;

        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.offset;

        if (maxScroll > 0) {
          final scrollFraction = (currentScroll / maxScroll).clamp(0.0, 1.0);
          progress.value = lerpDouble(progress.value, 0.05 + (0.95 * scrollFraction), 0.2)!;
        } else {
          progress.value = 0.05;
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => onScroll());

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    },
    [scrollController],
  );

  return progress.value;
}
