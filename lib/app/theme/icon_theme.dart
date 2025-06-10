// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/services/data/models/template.c.dart';

IconThemeData buildIconTheme(TemplateTheme templateTheme) {
  final averageSize = (templateTheme.icon.width + templateTheme.icon.height) / 2;

  return IconThemeData(
    size: averageSize.s,
  );
}
