// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/data/models/events_metadata.c.dart';

abstract class EventsMetadataBuilder {
  Future<List<EventsMetadata>> buildMetadata(List<EventReference> eventReferences);
}
