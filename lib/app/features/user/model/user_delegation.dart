// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'user_delegation.freezed.dart';

enum DelegationStatus { active, inactive, revoked }

@Freezed(copyWith: true, equal: true)
class UserDelegation with _$UserDelegation {
  const factory UserDelegation({
    required String pubkey,
    required Map<String, UserDelegate> delegates,
  }) = _UserDelegation;

  factory UserDelegation.fromEventMessage(EventMessage eventMessage) {
    //TODO:implement
    // final foo = eventMessage.tags

    return UserDelegation(
      pubkey: eventMessage.pubkey,
      delegates: {},
    );
  }
}

@Freezed(copyWith: true, equal: true)
class UserDelegate with _$UserDelegate {
  const factory UserDelegate({
    required String pubkey,
    required DateTime timestamp,
    required DelegationStatus status,
    List<String>? kinds,
  }) = _UserDelegate;
}
