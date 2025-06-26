// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/extensions/event_message.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_reference_converter.d.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_tags_converter.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';
import 'package:ion/app/features/user_metadata/database/user_metadata_database.m.dart';

@DataClassName('EventMessageDbModel')
class UserMetadataTable extends Table {
  TextColumn get id => text()();
  IntColumn get kind => integer()();
  TextColumn get pubkey => text()();
  TextColumn get masterPubkey => text()();
  IntColumn get createdAt => integer()();
  TextColumn get sig => text().nullable()();
  TextColumn get content => text()();
  TextColumn get tags => text().map(const EventTagsConverter())();
  TextColumn get eventReference => text().map(const EventReferenceConverter())();

  @override
  Set<Column> get primaryKey => {masterPubkey};
}

extension UserMetadataEntityExtension on UserMetadataEntity {
  Future<EventMessageDbModel> toEventMessageDbModel() async {
    final eventMessage = await toEventMessage(data);
    return EventMessageDbModel(
      id: eventMessage.id,
      sig: eventMessage.sig,
      kind: eventMessage.kind,
      tags: eventMessage.tags,
      pubkey: eventMessage.pubkey,
      content: eventMessage.content,
      createdAt: eventMessage.createdAt,
      masterPubkey: eventMessage.masterPubkey,
      eventReference: toEventReference(),
    );
  }

  static UserMetadataEntity fromEventMessageDbModel(EventMessageDbModel model) {
    final eventMessage = EventMessage(
      id: model.id,
      sig: model.sig,
      kind: model.kind,
      tags: model.tags,
      pubkey: model.pubkey,
      content: model.content,
      createdAt: model.createdAt,
    );
    return UserMetadataEntity.fromEventMessage(eventMessage);
  }
}
