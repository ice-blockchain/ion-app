// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/ion_connect/data/models/entity_expiration.c.dart';
import 'package:ion/app/features/ion_connect/data/models/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/data/models/related_pubkey.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';

part 'ion_connect_gift_wrap.c.freezed.dart';

@Freezed(equal: false)
class IonConnectGiftWrapEntity with IonConnectEntity, ImmutableEntity, _$IonConnectGiftWrapEntity {
  const factory IonConnectGiftWrapEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required int createdAt,
    required IonConnectGiftWrapData data,
  }) = _IonConnectGiftWrapEntity;

  const IonConnectGiftWrapEntity._();

  factory IonConnectGiftWrapEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return IonConnectGiftWrapEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.pubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: IonConnectGiftWrapData.fromEventMessage(eventMessage),
    );
  }

  static const int kind = 1059;
}

@freezed
class IonConnectGiftWrapData with _$IonConnectGiftWrapData {
  const factory IonConnectGiftWrapData({
    required String content,
    required EntityExpiration expiration,
    required List<String> kinds,
    required List<RelatedPubkey> relatedPubkeys,
  }) = _IonConnectGiftWrapData;

  const IonConnectGiftWrapData._();

  factory IonConnectGiftWrapData.fromEventMessage(EventMessage eventMessage) {
    final tags = groupBy(eventMessage.tags, (tag) => tag[0]);
    return IonConnectGiftWrapData(
      content: eventMessage.content,
      expiration: EntityExpiration.fromTag(tags[EntityExpiration.tagName]!.first),
      kinds: tags['k']!.map((tag) => tag[1]).toList(),
      relatedPubkeys: tags[RelatedPubkey.tagName]!.map(RelatedPubkey.fromTag).toList(),
    );
  }
}
