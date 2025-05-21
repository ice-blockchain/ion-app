// SPDX-License-Identifier: ice License 1.0

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/analytics_service/analytics_service_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_analytics_service_provider.c.g.dart';

class FirebaseAnalyticsService implements AnalyticsBackend {
  @override
  Future<void> logEvent(AnalyticsEvent event) async {
    return FirebaseAnalytics.instance.logEvent(
      name: event.name,
      parameters: event.parameters,
    );
  }
}

@Riverpod(keepAlive: true)
FirebaseAnalyticsService firebaseAnalyticsService(Ref ref) => FirebaseAnalyticsService();
