// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';

part 'event_reference.c.freezed.dart';

@Freezed(toStringOverride: false)
class EventReference with _$EventReference {
  const factory EventReference({
    required String eventId,
    required String pubkey,
  }) = _EventReference;

  const EventReference._();

  // TODO: use https://github.com/nostr-protocol/nips/blob/master/19.md#shareable-identifiers-with-extra-metadata ?
  factory EventReference.fromString(String input) {
    final parts = input.split(separator);
    return EventReference(eventId: parts[0], pubkey: parts[1]);
  }

  factory EventReference.fromIonConnectEntity(IonConnectEntity ionEntity) {
    return EventReference(eventId: ionEntity.id, pubkey: ionEntity.masterPubkey);
  }

  @override
  String toString() {
    return '$eventId$separator$pubkey';
  }

  static String separator = ':';
}
