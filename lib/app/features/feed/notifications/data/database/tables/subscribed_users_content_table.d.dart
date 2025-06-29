// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_reference_converter.d.dart';

enum ContentType {
  posts(0),
  stories(1),
  articles(2),
  videos(3);

  const ContentType(this.value);
  final int value;

  static ContentType fromValue(int value) {
    return ContentType.values.firstWhere((type) => type.value == value);
  }
}

@DataClassName('ContentNotification')
class SubscribedUsersContentTable extends Table {
  TextColumn get eventReference => text().map(const EventReferenceConverter())();

  IntColumn get createdAt => integer()();

  IntColumn get type => intEnum<ContentType>()();

  @override
  Set<Column> get primaryKey => {eventReference, type};
}
