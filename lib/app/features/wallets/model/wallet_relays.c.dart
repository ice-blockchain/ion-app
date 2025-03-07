import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/event_serializable.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';

part 'wallet_relays.c.freezed.dart';

@Freezed(equal: false)
class WalletRelaysEntity
    with IonConnectEntity, CacheableEntity, ImmutableEntity, _$WalletRelaysEntity {
  const factory WalletRelaysEntity({
    required String id,
    required String pubkey,
    required String masterPubkey,
    required String signature,
    required DateTime createdAt,
    required TestRelaysData data,
  }) = _WalletRelaysEntity;

  const WalletRelaysEntity._();

  factory WalletRelaysEntity.fromEventMessage(EventMessage eventMessage) {
    if (eventMessage.kind != kind) {
      throw IncorrectEventKindException(eventMessage.id, kind: kind);
    }

    return WalletRelaysEntity(
      id: eventMessage.id,
      pubkey: eventMessage.pubkey,
      masterPubkey: eventMessage.masterPubkey,
      signature: eventMessage.sig!,
      createdAt: eventMessage.createdAt,
      data: TestRelaysData.fromEventMessage(eventMessage),
    );
  }

  List<String> get urls => data.list.map((relay) => relay.url).toList();

  static const int kind = 1756;
}

@freezed
class TestRelaysData with _$TestRelaysData implements EventSerializable, ReplaceableEntityData {
  const factory TestRelaysData({
    required List<TestRelay> list,
  }) = _TestRelaysData;

  const TestRelaysData._();

  factory TestRelaysData.fromEventMessage(EventMessage eventMessage) {
    return TestRelaysData(
      list: [
        for (final tag in eventMessage.tags)
          if (tag[0] == TestRelay.tagName) TestRelay.fromTag(tag),
      ],
    );
  }

  @override
  FutureOr<EventMessage> toEventMessage(
    EventSigner signer, {
    List<List<String>> tags = const [],
    DateTime? createdAt,
  }) {
    return EventMessage.fromData(
      signer: signer,
      createdAt: createdAt,
      kind: WalletRelaysEntity.kind,
      tags: [
        ...tags,
        ...list.map((relay) => relay.toTag()),
      ],
      content: '',
    );
  }

  @override
  ReplaceableEventReference toReplaceableEventReference(String pubkey) {
    return ReplaceableEventReference(
      kind: WalletRelaysEntity.kind,
      pubkey: pubkey,
    );
  }
}

@freezed
class TestRelay with _$TestRelay {
  const factory TestRelay({
    required String url,
    @Default(true) bool read,
    @Default(true) bool write,
  }) = _TestRelay;

  const TestRelay._();

  factory TestRelay.fromTag(List<String> tag) {
    if (tag[0] != tagName) {
      throw IncorrectEventTagNameException(actual: tag[0], expected: tagName);
    }
    return TestRelay(
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
