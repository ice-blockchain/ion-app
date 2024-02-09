import 'package:flutter/material.dart';
import 'package:ice/generated/app_localizations.dart';

extension ThemeGetter on BuildContext {
  /// Usage example: `context.theme`
  ThemeData get theme => Theme.of(this);
}

extension I18nGetter on BuildContext {
  I18n get i18n => I18n.of(this)!;
}
