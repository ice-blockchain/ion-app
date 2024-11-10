// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/nostr/model/event_serializable.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:nostr_dart/nostr_dart.dart';

part 'user_relays.freezed.dart';

@freezed
class UserRelaysEntity with _$UserRelaysEntity implements CacheableEntity, NostrEntity {
  const factory UserRelaysEntity({
    required String id,
    required String pubkey,
    required DateTime createdAt,
    required UserRelaysData data,
  }) = _UserRelaysEntity;

  const UserRelaysEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/65.md
  factory UserRelaysEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventId: eventMessage.id, kind: kind);
    }

    return UserRelaysEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      createdAt: eventMessage.createdAt,
      data: UserRelaysData.fromEventMessage(eventMessage),
    );
  }

  List<String> get urls => data.list.map((relay) => relay.url).toList();

  @override
  String get cacheKey => pubkey;

  @override
  Type get cacheType => UserRelaysEntity;

  static const int kind = 10002;
}

@freezed
class UserRelaysData with _$UserRelaysData implements EventSerializable {
  const factory UserRelaysData({
    required List<UserRelay> list,
  }) = _UserRelaysData;

  const UserRelaysData._();

  factory UserRelaysData.fromEventMessage(EventMessage eventMessage) {
    return UserRelaysData(
      list: eventMessage.tags.where((tag) => tag[0] == 'r').map(UserRelay.fromTag).toList(),
    );
  }

  @override
  EventMessage toEventMessage(EventSigner signer) {
    return EventMessage.fromData(
      signer: signer,
      kind: UserRelaysEntity.kind,
      tags: list.map((relay) => relay.toTag()).toList(),
      content: '',
    );
  }
}

@freezed
class UserRelay with _$UserRelay {
  const factory UserRelay({
    required String url,
    @Default(true) bool read,
    @Default(true) bool write,
  }) = _UserRelay;

  const UserRelay._();

  factory UserRelay.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    return UserRelay(
      url: tag[1],
      read: tag.length == 2 || tag[2] == 'read',
      write: tag.length == 2 || tag[2] == 'write',
    );
  }

  List<String> toTag() {
    final tag = [tagName, url];
    if (read && !write) {
      tag.add('read');
    } else if (write && !read) {
      tag.add('write');
    }
    return tag;
  }

  static const String tagName = 'r';
}
