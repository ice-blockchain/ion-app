// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/router/app_routes.gr.dart';

class ProfileNavigationUtils {
  static Future<T?> navigateToProfile<T extends Object?>(
    BuildContext context,
    String pubkey,
  ) {
    final currentState = GoRouterState.of(context);
    final currentPath = currentState.matchedLocation;

    final isCurrentlyOnProfile = currentPath.contains('/user/');

    if (isCurrentlyOnProfile) {
      final currentPubkey = currentState.pathParameters['pubkey'];
      if (currentPubkey == pubkey) {
        return Future.value();
      }
    }

    return ProfileRoute(pubkey: pubkey).push<T>(context);
  }
}
