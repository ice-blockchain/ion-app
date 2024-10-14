// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'user_delegation.freezed.dart';

enum DelegationStatus { active, inactive, revoked }

@Freezed(copyWith: true, equal: true)
class UserDelegation with _$UserDelegation {
  const factory UserDelegation({
    required String pubkey,
    required List<UserDelegate> delegates,
  }) = _UserDelegation;

  const UserDelegation._();

  /// https://github.com/nostr-protocol/nips/pull/1482/files
  factory UserDelegation.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event with kind ${eventMessage.kind}, expected $kind');
    }

    final delegates =
        eventMessage.tags.where((tag) => tag[0] == 'p').map(UserDelegate.fromTag).toList();

    return UserDelegation(
      pubkey: eventMessage.pubkey,
      delegates: delegates,
    );
  }

  bool validate(EventMessage message) {
    final currentDelegates = delegates.fold(<String, UserDelegate>{}, (currentDelegates, delegate) {
      /// `inactive` and `revoked` attestations invalidate all previous `active` attestations,
      /// and subsequent `active` attestations are considered invalid as well
      if (currentDelegates[pubkey]?.status == DelegationStatus.inactive ||
          currentDelegates[pubkey]?.status == DelegationStatus.revoked) {
        return currentDelegates;
      }
      currentDelegates[delegate.pubkey] = delegate;
      return currentDelegates;
    });

    final delegate = currentDelegates[message.pubkey];
    if (delegate != null) {
      final kinds = delegate.kinds;
      return delegate.status == DelegationStatus.active &&
          (kinds == null || kinds.contains(message.kind));
    }
    return false;
  }

  bool hasDelegateFor({required String pubkey}) {
    return delegates.any((delegate) => delegate.pubkey == pubkey);
  }

  List<List<String>> get tags {
    return delegates.map((delegate) => delegate.toTag()).toList();
  }

  static const int kind = 10100;
}

@Freezed(copyWith: true, equal: true)
class UserDelegate with _$UserDelegate {
  const factory UserDelegate({
    required String pubkey,
    required DateTime time,
    required DelegationStatus status,
    @Default('') String relay,
    List<int>? kinds,
  }) = _UserDelegate;

  const UserDelegate._();

  factory UserDelegate.fromTag(List<String> tag) {
    /// "p", <pubkey>, <main relay URL>, <attestation string>
    final [_, pubkey, relay, attestationString] = tag;

    /// active:<timestamp>:<kinds comma separated list, optional>
    final attestation = attestationString.split(':');
    final statusName = attestation[0];
    final timestamp = attestation[1];
    final kindsString = (attestation.length > 2) ? attestation[2] : null;

    final status = DelegationStatus.values.byName(statusName);
    final time = DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp));
    final kinds = kindsString?.split(',').map(int.parse).toList();

    return UserDelegate(pubkey: pubkey, relay: relay, status: status, time: time, kinds: kinds);
  }

  List<String> toTag() {
    final attestationParts = [status.toShortString(), time.microsecondsSinceEpoch];
    if (kinds.emptyOrValue.isNotEmpty) {
      attestationParts.add(kinds!.join(','));
    }
    return ['p', pubkey, relay, attestationParts.join(':')];
  }
}
