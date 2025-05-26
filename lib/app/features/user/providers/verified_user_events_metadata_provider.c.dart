// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/events_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/events_metadata_builder.dart';
import 'package:ion/app/features/user/model/badges/verified_badge_data.dart';
import 'package:ion/app/features/user/providers/badges_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'verified_user_events_metadata_provider.c.g.dart';

class VerifiedUserEventsMetadataBuilder implements EventsMetadataBuilder {
  VerifiedUserEventsMetadataBuilder({
    required VerifiedBadgeEntities verifiedBadgeData,
  }) : _verifiedBadgeData = verifiedBadgeData;

  final VerifiedBadgeEntities _verifiedBadgeData;

  @override
  Future<List<EventsMetadata>> buildMetadata(List<EventReference> eventReferences) async {
    final result = <EventsMetadata>[];

    if (_verifiedBadgeData.awardEntity != null) {
      result.add(
        EventsMetadata(
          eventReferences: eventReferences,
          metadata: await _verifiedBadgeData.awardEntity!.toEntityEventMessage(),
        ),
      );
    }
    if (_verifiedBadgeData.definitionEntity != null) {
      result.add(
        EventsMetadata(
          eventReferences: eventReferences,
          metadata: await _verifiedBadgeData.definitionEntity!.toEntityEventMessage(),
        ),
      );
    }

    return result;
  }
}

@riverpod
Future<VerifiedUserEventsMetadataBuilder> verifiedUserEventsMetadataBuilder(Ref ref) async {
  final verifiedBadgeData = await ref.watch(currentUserVerifiedBadgeDataProvider.future);
  if (verifiedBadgeData == null) {
    throw UserEventsMetadataBuilderException();
  }
  return VerifiedUserEventsMetadataBuilder(verifiedBadgeData: verifiedBadgeData);
}
