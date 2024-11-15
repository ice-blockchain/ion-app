// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/generated/app_localizations.dart';

extension ThemeGetter on BuildContext {
  /// Usage example: `context.theme`
  ThemeData get theme => Theme.of(this);
}

extension I18nGetter on BuildContext {
  I18n get i18n => I18n.of(this)!;
}

extension NavigatorExt on BuildContext {
  bool get isCurrentRoute => ModalRoute.of(this)?.isCurrent ?? false;
}
