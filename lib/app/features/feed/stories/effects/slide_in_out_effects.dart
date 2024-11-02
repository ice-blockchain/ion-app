// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

final List<Effect<dynamic>> topSlideInOutEffects = [
  SlideEffect(
    begin: const Offset(0, -1),
    end: Offset.zero,
    duration: 300.ms,
    curve: Curves.easeOut,
  ),
  FadeEffect(
    begin: 0,
    end: 1,
    duration: 300.ms,
  ),
  ThenEffect(delay: 5.seconds),
  FadeEffect(
    begin: 1,
    end: 0,
    duration: 300.ms,
  ),
  SlideEffect(
    begin: Offset.zero,
    end: const Offset(0, -1),
    duration: 300.ms,
    curve: Curves.easeIn,
  ),
];
