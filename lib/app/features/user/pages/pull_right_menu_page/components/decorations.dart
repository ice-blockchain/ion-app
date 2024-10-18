// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';

class Decorations {
  static BoxDecoration borderBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.theme.appColors.secondaryBackground,
      border: Border.all(
        color: context.theme.appColors.onTerararyFill,
      ),
      borderRadius: BorderRadius.circular(30.0.s),
    );
  }
}
