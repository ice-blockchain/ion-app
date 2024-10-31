// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'user_delegation.freezed.dart';

enum DelegationStatus { active, inactive, revoked }

@freezed
class UserDelegationEntity with _$UserDelegationEntity implements CacheableEntity, NostrEntity {
  const factory UserDelegationEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required UserDelegationData data,
  }) = _UserDelegationEntity;

  const UserDelegationEntity._();

  /// https://github.com/nostr-protocol/nips/pull/1482/files
  factory UserDelegationEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(actual: eventMessage.kind, excepted: kind);
    }

    return UserDelegationEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      data: UserDelegationData.fromEventMessage(eventMessage),
    );
  }

  @override
  String get cacheKey => pubkey;

  @override
  Type get cacheType => UserDelegationEntity;

  static const int kind = 10100;
}

@freezed
class UserDelegationData with _$UserDelegationData {
  const factory UserDelegationData({
    required List<UserDelegate> delegates,
  }) = _UserDelegationData;

  factory UserDelegationData.fromEventMessage(EventMessage eventMessage) {
    final delegates =
        eventMessage.tags.where((tag) => tag[0] == 'p').map(UserDelegate.fromTag).toList();

    return UserDelegationData(
      delegates: delegates,
    );
  }

  const UserDelegationData._();

  bool validate(EventMessage message) {
    final currentDelegates = delegates.fold(<String, UserDelegate>{}, (currentDelegates, delegate) {
      /// `inactive` and `revoked` attestations invalidate all previous `active` attestations,
      /// and subsequent `active` attestations are considered invalid as well
      if (currentDelegates[delegate.pubkey]?.status == DelegationStatus.inactive ||
          currentDelegates[delegate.pubkey]?.status == DelegationStatus.revoked) {
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
}

@freezed
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
