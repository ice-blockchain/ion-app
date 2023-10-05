import 'package:flutter/material.dart';

extension ThemeGetter on BuildContext {
  /// Usage example: `context.theme`
  ThemeData get theme => Theme.of(this);
}
