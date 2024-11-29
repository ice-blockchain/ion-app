// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

void useKeyboardScrollHandler({
  required ScrollController scrollController,
  required List<GlobalKey> keysToMeasure,
}) {
  final keyboardVisibilityController = KeyboardVisibilityController();

  useEffect(
    () {
      final subscription = keyboardVisibilityController.onChange.listen((isVisible) {
        if (isVisible) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              final extraHeight = keysToMeasure.fold<double>(
                0,
                (totalHeight, key) {
                  final box = key.currentContext?.findRenderObject() as RenderBox?;
                  return totalHeight + (box?.size.height ?? 0.0);
                },
              );

              final maxExtent = scrollController.position.maxScrollExtent + extraHeight;
              scrollController.animateTo(
                maxExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      });

      return subscription.cancel;
    },
    [],
  );
}
