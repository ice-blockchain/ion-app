part of '../chat_database.c.dart';

class MessageStatusTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventMessageId => text()();
  TextColumn get masterPubkey => text().nullable()();
  IntColumn get status => intEnum<MessageDeliveryStatus>()();
}
