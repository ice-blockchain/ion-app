// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';

abstract class SelectableType {
  String getTitle(BuildContext context);

  String getDescription(BuildContext context);

  String get iconAsset;
}
