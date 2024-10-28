// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppRouterNotifier extends ChangeNotifier {
  AppRouterNotifier(this.ref) {
    ref
      ..listen(authProvider, (_, __) => notifyListeners())
      ..listen(initAppProvider, (_, __) => notifyListeners())
      ..listen(splashProvider, (_, __) => notifyListeners())
      ..listen(onboardingCompleteProvider, (_, __) => notifyListeners());
  }

  final Ref ref;
}
