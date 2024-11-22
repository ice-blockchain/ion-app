// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';

final random = Random();

final storyBorderGradients = [
  const SweepGradient(
    colors: [
      Color(0xFFEF1D4F),
      Color(0xFFFF9F0E),
      Color(0xFFFFBB0E),
      Color(0xFFFF012F),
      Color(0xFFEF1D4F),
    ],
    stops: [0.0, 0.21, 0.47, 0.77, 1],
    startAngle: pi / 2,
    endAngle: pi * 5 / 2,
    tileMode: TileMode.repeated,
  ),
  const SweepGradient(
    colors: [
      Color(0xFF0166FF),
      Color(0XFF00DDB5),
      Color(0XFF3800D6),
      Color(0XFF0166FF),
    ],
    stops: [0.0, 0.30, 0.72, 1],
    startAngle: pi / 2,
    endAngle: pi * 5 / 2,
    tileMode: TileMode.repeated,
  ),
  const SweepGradient(
    colors: [
      Color(0xFFAE01FF),
      Color(0XFF1F00DD),
      Color(0XFF0AA7FF),
      Color(0XFFC100BA),
    ],
    stops: [0.0, 0.30, 0.72, 0.97],
    startAngle: pi / 2,
    endAngle: pi * 5 / 2,
    tileMode: TileMode.repeated,
  ),
  const SweepGradient(
    colors: [
      Color(0xFF00AFA5),
      Color(0XFF1B76FF),
      Color(0XFF0AFFFF),
      Color(0XFF00C1B6),
    ],
    stops: [0.0, 0.30, 0.72, 0.97],
    startAngle: pi / 2,
    endAngle: pi * 5 / 2,
    tileMode: TileMode.repeated,
  ),
];
