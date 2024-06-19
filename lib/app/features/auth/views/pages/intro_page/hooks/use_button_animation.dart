import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Animation<double> useButtonAnimation({
  Duration delay = const Duration(seconds: 3),
  Duration duration = const Duration(milliseconds: 500),
}) {
  final controller = useAnimationController(duration: duration);
  late final Animation<double> animation = CurvedAnimation(
    parent: controller,
    curve: Curves.easeOutBack,
  );

  useEffect(
    () {
      final timer = Timer(delay, controller.forward);
      return timer.cancel;
    },
    <Object?>[],
  );

  return animation;
}
