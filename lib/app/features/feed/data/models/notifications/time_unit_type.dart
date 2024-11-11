// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';

enum TimeUnitType {
  days,
  hours;

  String getTitle(BuildContext context, int value) => switch (this) {
        TimeUnitType.days => context.i18n.d(value),
        TimeUnitType.hours => context.i18n.h(value),
      };
}
