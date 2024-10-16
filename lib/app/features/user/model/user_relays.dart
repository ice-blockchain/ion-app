// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'user_relays.freezed.dart';

@freezed
class UserRelay with _$UserRelay {
  const factory UserRelay({
    required String url,
    @Default(true) bool read,
    @Default(true) bool write,
  }) = _UserRelay;

  const UserRelay._();

  factory UserRelay.fromTag(List<String> tag) {
    return UserRelay(
      url: tag[1],
      read: tag.length == 2 || tag[2] == 'read',
      write: tag.length == 2 || tag[2] == 'write',
    );
  }

  List<String> toTag() {
    final tag = ['r', url];
    if (read && !write) {
      tag.add('read');
    } else if (write && !read) {
      tag.add('write');
    }
    return tag;
  }
}

@freezed
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
      list: eventMessage.tags.where((tag) => tag[0] == 'r').map(UserRelay.fromTag).toList(),
    );
  }

  const UserRelays._();

  EventMessage toEventMessage(KeyStore keyStore) {
    return EventMessage.fromData(
      signer: keyStore,
      kind: kind,
      tags: list.map((relay) => relay.toTag()).toList(),
      content: '',
    );
  }

  static const int kind = 10002;
}
