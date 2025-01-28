// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';

abstract mixin class IonConnectEntityReferecenable {
  EventReference toEventReference();
}

@immutable
abstract mixin class IonConnectEntity {
  String get id;
  String get pubkey;
  String get masterPubkey;
  String get signature;
  DateTime get createdAt;

  FutureOr<EventMessage> toEventMessage(EventSerializable data) {
    return data.toEventMessage(
      createdAt: createdAt,
      SimpleSigner(pubkey, signature),
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

mixin ImmutableEntity on IonConnectEntity implements IonConnectEntityReferecenable {
  @override
  ImmutableEventReference toEventReference() {
    return ImmutableEventReference(eventId: id, pubkey: masterPubkey);
  }
}

mixin ReplaceableEntity on IonConnectEntity implements IonConnectEntityReferecenable {
  ReplaceableEntityData get data;
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
