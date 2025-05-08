// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';

@immutable
abstract mixin class IonConnectEntity implements IonConnectEntityReferenceable {
  String get id;
  String get pubkey;
  String get masterPubkey;
  String get signature;
  DateTime get createdAt;

  FutureOr<EventMessage> toEventMessage(EventSerializable data) {
    return data.toEventMessage(
      SimpleSigner(pubkey, signature),
      createdAt: createdAt,
      tags: [
        ['b', masterPubkey],
      ],
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IonConnectEntity && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

abstract mixin class IonConnectEntityReferenceable {
  EventReference toEventReference();
}

mixin ImmutableEntity on IonConnectEntity implements IonConnectEntityReferenceable {
  @override
  ImmutableEventReference toEventReference() {
    return ImmutableEventReference(eventId: id, pubkey: masterPubkey);
  }
}

mixin ReplaceableEntity<T extends ReplaceableEntityData> on IonConnectEntity
    implements IonConnectEntityReferenceable {
  ReplaceableEntityData get data;

  @override
  ReplaceableEventReference toEventReference() {
    return data.toReplaceableEventReference(masterPubkey);
  }
}

abstract class ReplaceableEntityData {
  ReplaceableEventReference toReplaceableEventReference(String pubkey);
}

class SimpleSigner implements EventSigner {
  SimpleSigner(this.publicKey, this.signature);

  @override
  final String publicKey;

  @override
  String get privateKey => '';

  final String signature;

  @override
  FutureOr<String> sign({required String message}) => signature;
}
