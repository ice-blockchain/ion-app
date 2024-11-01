// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';

abstract class MainModalListItem {
  String getDisplayName(BuildContext context);
  String getDescription(BuildContext context);

  Color getIconColor(BuildContext context);

  String get iconAsset;
}
