// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/hooks/use_route_presence.dart';

void useStatusBarColor() {
  final context = useContext();
  useRoutePresence(
    onBecameInactive: _clearStatusBarColor,
    onBecameActive: () => _setStatusBarColor(context),
  );
  useEffect(
    () {
      return _clearStatusBarColor;
    },
    [],
  );
}

void _setStatusBarColor(BuildContext context) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: context.theme.appColors.primaryText,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
}

void _clearStatusBarColor() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
}
