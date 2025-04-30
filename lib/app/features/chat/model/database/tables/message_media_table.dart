// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

class MessageMediaTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get status => intEnum<MessageMediaStatus>()();
  TextColumn get remoteUrl => text().nullable()();
  TextColumn get cacheKey => text().nullable()();
  TextColumn get eventMessageId => text()();
}

enum MessageMediaStatus {
  created,
  processing,
  completed,
  failed,
}
