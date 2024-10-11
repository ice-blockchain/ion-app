// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'user_relays.freezed.dart';

@Freezed(copyWith: true, equal: true)
class UserRelay with _$UserRelay {
  const factory UserRelay({
    required String url,
    required bool read,
    required bool write,
  }) = _UserRelay;
}

@Freezed(copyWith: true, equal: true)
class UserRelays with _$UserRelays {
  const factory UserRelays({
    required String pubkey,
    required List<UserRelay> list,
  }) = _UserRelays;

  /// https://github.com/nostr-protocol/nips/blob/master/65.md
  factory UserRelays.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw Exception('Incorrect event with kind ${eventMessage.kind}, expected $kind');
    }

    return UserRelays(
      pubkey: eventMessage.pubkey,
      list: eventMessage.tags
          .where((tag) => tag[0] == 'r')
          .map(
            (tag) => UserRelay(
              url: tag[1],
              read: tag.length == 2 || tag[2] == 'read',
              write: tag.length == 2 || tag[2] == 'write',
            ),
          )
          .toList(),
    );
  }

  static const int kind = 10002;
}
