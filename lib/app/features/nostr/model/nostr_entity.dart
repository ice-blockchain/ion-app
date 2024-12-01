// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:nostr_dart/nostr_dart.dart';

@immutable
abstract mixin class NostrEntity {
  String get id;
  String get pubkey;
  String get masterPubkey;
  DateTime get createdAt;

  static String getMasterPubkey(EventMessage eventMessage) {
    final masterPubkey =
        eventMessage.tags.firstWhereOrNull((tags) => tags[0] == 'b')?.elementAtOrNull(1);

    if (masterPubkey == null) {
      throw MasterPubkeyNotFoundException(eventId: eventMessage.id);
    }

    return masterPubkey;
  }

  @override
  bool operator ==(Object other) {
    return other is NostrEntity && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
