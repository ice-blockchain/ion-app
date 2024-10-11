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

  const UserDelegation._();

  /// https://github.com/nostr-protocol/nips/pull/1482/files
  factory UserDelegation.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event with kind ${eventMessage.kind}, expected $kind');
    }

    final delegates = eventMessage.tags.fold(<String, UserDelegate>{}, (delegates, tag) {
      if (tag[0] != 'p') {
        return delegates;
      }

      /// "p", <pubkey>, <main relay URL>, <attestation string>
      final [_, pubkey, relay, attestationString] = tag;

      /// `inactive` and `revoked` attestations invalidate all previous `active` attestations,
      /// and subsequent `active` attestations are considered invalid as well
      if (delegates[pubkey]?.status == DelegationStatus.inactive ||
          delegates[pubkey]?.status == DelegationStatus.revoked) {
        return delegates;
      }

      /// active:<timestamp>:<kinds comma separated list, optional>
      final attestation = attestationString.split(':');
      final statusName = attestation[0];
      final timestamp = attestation[1];
      final kindsString = (attestation.length > 2) ? attestation[2] : null;

      final status = DelegationStatus.values.byName(statusName);
      final time = DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp));
      final kinds = kindsString?.split(',').map(int.parse).toList();

      delegates[pubkey] = UserDelegate(pubkey: pubkey, status: status, time: time, kinds: kinds);

      return delegates;
    });

    return UserDelegation(
      pubkey: eventMessage.pubkey,
      delegates: delegates,
    );
  }

  bool validate(EventMessage message) {
    final delegate = delegates[message.pubkey];
    if (delegate != null) {
      final kinds = delegate.kinds;
      return delegate.status == DelegationStatus.active &&
          (kinds == null || kinds.contains(message.kind));
    }
    return false;
  }

  static const int kind = 10100;
}

@Freezed(copyWith: true, equal: true)
class UserDelegate with _$UserDelegate {
  const factory UserDelegate({
    required String pubkey,
    required DateTime time,
    required DelegationStatus status,
    List<int>? kinds,
  }) = _UserDelegate;
}
