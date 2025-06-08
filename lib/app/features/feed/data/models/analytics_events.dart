// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/services/providers/analytics_service/analytics_service_provider.c.dart';

class PostViewAnalyticsEvent implements AnalyticsEvent {
  PostViewAnalyticsEvent(this.eventReference);

  final EventReference eventReference;

  @override
  String get name => 'post_view';

  @override
  Map<String, Object>? get parameters => {
        'reference': eventReference.toString(),
      };
}
