// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';

abstract class SelectableOption {
  String getLabel(BuildContext context);
  Widget getIcon(BuildContext context);
}
