// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/events_metadata.c.dart';

abstract class EventsMetadataBuilder {
  Future<List<EventsMetadata>> buildMetadata(List<EventReference> eventReferences);
}
