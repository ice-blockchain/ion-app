// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/events_metadata.c.dart';
import 'package:ion/app/features/ion_connect/model/events_metadata_builder.dart';
import 'package:ion/app/features/user/model/user_delegation.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/providers/user_delegation_provider.c.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_events_metadata_provider.c.g.dart';

class UserEventsMetadataBuilder implements EventsMetadataBuilder {
  UserEventsMetadataBuilder({
    required UserMetadataEntity currentUserMetadata,
    required UserDelegationEntity currentUserDelegation,
  })  : _currentUserMetadata = currentUserMetadata,
        _currentUserDelegation = currentUserDelegation;

  final UserMetadataEntity _currentUserMetadata;
  final UserDelegationEntity _currentUserDelegation;

  @override
  Future<List<EventsMetadata>> buildMetadata(List<EventReference> eventReferences) async {
    return [
      EventsMetadata(
        eventReferences: eventReferences,
        metadata: await _currentUserMetadata.toEntityEventMessage(),
      ),
      EventsMetadata(
        eventReferences: eventReferences,
        metadata: await _currentUserDelegation.toEntityEventMessage(),
      ),
    ];
  }
}

@riverpod
Future<UserEventsMetadataBuilder> userEventsMetadataBuilder(Ref ref) async {
  final (
    currentUserMetadata,
    currentUserDelegation,
  ) = await (
    ref.watch(currentUserMetadataProvider.future),
    ref.watch(currentUserDelegationProvider.future),
  ).wait;
  if (currentUserMetadata == null || currentUserDelegation == null) {
    throw UserEventsMetadataBuilderException();
  }
  return UserEventsMetadataBuilder(
    currentUserMetadata: currentUserMetadata,
    currentUserDelegation: currentUserDelegation,
  );
}
