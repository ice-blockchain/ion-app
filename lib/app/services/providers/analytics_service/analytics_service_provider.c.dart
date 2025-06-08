// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:ion/app/services/providers/firebase/firebase_analytics_service_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_service_provider.c.g.dart';

abstract class AnalyticsEvent {
  String get name;
  Map<String, Object>? get parameters;
}

abstract class AnalyticsBackend {
  Future<void> logEvent(AnalyticsEvent event);
}

class AnalyticsService {
  AnalyticsService({required this.backends});

  final List<AnalyticsBackend> backends;

  Future<void> logEvent(AnalyticsEvent event) async {
    try {
      await Future.wait(backends.map((backend) => backend.logEvent(event)));
    } catch (error, stackTrace) {
      Logger.error(error, stackTrace: stackTrace, message: 'Failed to log event: $error');
    }
  }
}

@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  final firebaseBackend = ref.watch(firebaseAnalyticsServiceProvider);
  return AnalyticsService(
    backends: [
      firebaseBackend,
    ],
  );
}
