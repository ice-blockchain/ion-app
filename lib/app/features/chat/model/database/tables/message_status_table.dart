// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

class MessageStatusTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sharedId => text()();
  TextColumn get pubkey => text()();
  TextColumn get masterPubkey => text()();
  IntColumn get status => intEnum<MessageDeliveryStatus>()();
}
