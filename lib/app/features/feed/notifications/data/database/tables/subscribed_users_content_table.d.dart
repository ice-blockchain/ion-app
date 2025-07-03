// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/feed/notifications/data/model/content_type.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_reference_converter.d.dart';

@DataClassName('ContentNotification')
class SubscribedUsersContentTable extends Table {
  TextColumn get eventReference => text().map(const EventReferenceConverter())();

  IntColumn get createdAt => integer()();

  IntColumn get type => intEnum<ContentType>()();

  @override
  Set<Column> get primaryKey => {eventReference, type};
}
