// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/user/model/user_notifications_type.dart';

part 'account_notifications_sets.c.freezed.dart';

enum AccountNotificationSetType {
  posts(dTagName: 'in_app_notifications_posts'),
  stories(dTagName: 'in_app_notifications_stories'),
  articles(dTagName: 'in_app_notifications_articles'),
  videos(dTagName: 'in_app_notifications_videos');

  const AccountNotificationSetType({required this.dTagName});

  final String dTagName;

  static AccountNotificationSetType? fromUserNotificationType(UserNotificationsType type) {
    return switch (type) {
      UserNotificationsType.posts => AccountNotificationSetType.posts,
      UserNotificationsType.stories => AccountNotificationSetType.stories,
      UserNotificationsType.articles => AccountNotificationSetType.articles,
      UserNotificationsType.videos => AccountNotificationSetType.videos,
      UserNotificationsType.none => null,
    };
  }
}

@Freezed(equal: false)
class AccountNotificationSetEntity
    with IonConnectEntity, CacheableEntity, ReplaceableEntity, _$AccountNotificationSetEntity {
  const factory AccountNotificationSetEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required int createdAt,
    required AccountNotificationSetData data,
  }) = _AccountNotificationSetEntity;

  const AccountNotificationSetEntity._();

  /// https://github.com/nostr-protocol/nips/blob/master/51.md#sets
  factory AccountNotificationSetEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return AccountNotificationSetEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: AccountNotificationSetData.fromEventMessage(eventMessage),
    );
  }

  static const int kind = 30000;
}

@freezed
class AccountNotificationSetData
    with _$AccountNotificationSetData
    implements EventSerializable, ReplaceableEntityData {
  const factory AccountNotificationSetData({
    required AccountNotificationSetType type,
    required List<String> userPubkeys,
  }) = _AccountNotificationSetData;

  const AccountNotificationSetData._();

  factory AccountNotificationSetData.fromEventMessage(EventMessage eventMessage) {
    final dTag = eventMessage.tags
        .firstWhere((tag) => tag[0] == 'd', orElse: () => ['d', ''])
        .elementAtOrNull(1);

    final type = AccountNotificationSetType.values.firstWhere(
      (t) => t.dTagName == dTag,
      orElse: () => AccountNotificationSetType.posts,
    );

    final userPubkeys = eventMessage.tags
        .where((tag) => tag[0] == 'p' && tag.length > 1)
        .map((tag) => tag[1])
        .toList();

    return AccountNotificationSetData(
      type: type,
      userPubkeys: userPubkeys,
    );
  }

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    int? createdAt,
  }) {
    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: AccountNotificationSetEntity.kind,
      tags: [
        ...tags,
        ['d', type.dTagName],
        ...userPubkeys.map((pubkey) => ['p', pubkey]),
      ],
      content: '',
    );
  }

  @override
  ReplaceableEventReference toReplaceableEventReference(String pubkey) {
    return ReplaceableEventReference(
      kind: AccountNotificationSetEntity.kind,
      pubkey: pubkey,
      dTag: type.dTagName,
    );
  }
}
