// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ion_database.c.g.dart';

@Riverpod(keepAlive: true)
Future<IONDatabase> ionDatabase(Ref ref) async => IONDatabase();

@DriftDatabase(tables: [DbEventMessages])
class IONDatabase extends _$IONDatabase {
  IONDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'ion_database');
  }
}

// Table for DbEventMessage
@UseRowClass(DbEventMessage)
class DbEventMessages extends Table {
  TextColumn get id => text()();
  TextColumn get sig => text()();
  TextColumn get tags => text()();
  TextColumn get pubkey => text()();
  IntColumn get kind => integer()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
}

// As it is the only model needed better to keep it in the same file
class DbEventMessage implements Insertable<DbEventMessage> {
  DbEventMessage({
    required this.id,
    required this.sig,
    required this.pubkey,
    required this.kind,
    required this.tags,
    required this.content,
    required this.createdAt,
  });

  factory DbEventMessage.fromEventMessage(EventMessage eventMessage) {
    return DbEventMessage(
      id: eventMessage.id,
      sig: eventMessage.sig,
      kind: eventMessage.kind,
      pubkey: eventMessage.pubkey,
      content: eventMessage.content,
      createdAt: eventMessage.createdAt,
      tags: jsonEncode(eventMessage.tags),
    );
  }

  EventMessage toEventMessage() {
    return EventMessage(
      id: id,
      sig: sig,
      kind: kind,
      pubkey: pubkey,
      content: content,
      createdAt: createdAt,
      tags: (jsonDecode(tags) as List<dynamic>)
          .map((e) => (e as List<dynamic>).map((e) => e as String).toList())
          .toList(),
    );
  }

  final int kind;
  final String id;
  final String pubkey;
  final String tags;
  final String content;
  final String sig;
  final DateTime createdAt;

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return DbEventMessagesCompanion(
      id: Value(id),
      sig: Value(sig),
      kind: Value(kind),
      pubkey: Value(pubkey),
      tags: Value(tags),
      content: Value(content),
      createdAt: Value(createdAt),
    ).toColumns(nullToAbsent);
  }
}

// Example of usage
/*
 final ionDatabase = ref.watch(ionDatabaseProvider).requireValue;

  final eventMessage = EventMessage(
    sig: '',
    kind: 14,
    id: '124',
    pubkey: '123',
    createdAt: DateTime.now(),
    tags: const [
      ['p', '123', '123'],
      ['p', '123', '123'],
      ['e', '123', '123', 'reply'],
      ['subject', '123'],
    ],
    content: '123',
  );

  await ionDatabase.into(ionDatabase.dbEventMessages).insert(
        DbEventMessage.fromEventMessage(eventMessage),
      );

  final allDbEventMessages = await ionDatabase.select(ionDatabase.dbEventMessages).get();
  final dbEventMessage = allDbEventMessages.first;

  print(dbEventMessage.toEventMessage());
*/
