// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:nostr_dart/nostr_dart.dart';

@immutable
abstract mixin class NostrEntity {
  String get id;
  String get pubkey;
  String get masterPubkey;
  String get signature;
  DateTime get createdAt;

  FutureOr<EventMessage> toEventMessage(EventSerializable data) {
    return data.toEventMessage(
      createdAt: createdAt,
      _SimpleSigner(pubkey, signature),
      tags: [
        ['b', masterPubkey],
      ],
    );
  }

  @override
  bool operator ==(Object other) {
    return other is NostrEntity && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

class _SimpleSigner implements EventSigner {
  _SimpleSigner(this.publicKey, this.signature);

  @override
  final String publicKey;

  final String signature;

  @override
  FutureOr<String> sign({required String message}) => signature;
}
