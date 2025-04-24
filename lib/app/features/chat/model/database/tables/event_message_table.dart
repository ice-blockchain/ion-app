// SPDX-License-Identifier: ice License 1.0

part of '../chat_database.c.dart';

// Preserver the order of the columns as they are used in the DB viewer
@UseRowClass(EventMessageRowClass)
class EventMessageTable extends Table {
  TextColumn get id => text()();
  IntColumn get kind => integer()();
  TextColumn get sharedId => text().nullable()();
  TextColumn get content => text()();
  TextColumn get pubkey => text()();
  TextColumn get tags => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get sig => text().nullable()();
  

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// As it is the only custom model needed better to keep it in the same file
class EventMessageRowClass implements Insertable<EventMessageRowClass> {
  EventMessageRowClass({
    required this.id,
    required this.kind,
    required this.tags,
    required this.pubkey,
    required this.content,
    required this.sharedId,
    required this.createdAt,
    this.sig,
    this.conversationId,
  });

  factory EventMessageRowClass.fromEventMessage(EventMessage eventMessage) {
    return EventMessageRowClass(
      id: eventMessage.id,
      sig: eventMessage.sig,
      kind: eventMessage.kind,
      pubkey: eventMessage.pubkey,
      content: eventMessage.content,
      sharedId: eventMessage.sharedId,
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
  final String tags;
  final String pubkey;
  final String content;
  final String? sig;
  final String? sharedId;
  final String? conversationId;
  final DateTime createdAt;

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    return EventMessageTableCompanion(
      id: Value(id),
      sig: Value(sig),
      kind: Value(kind),
      tags: Value(tags),
      pubkey: Value(pubkey),
      content: Value(content),
      sharedId: Value(sharedId),
      createdAt: Value(createdAt),
    ).toColumns(nullToAbsent);
  }

  EventMessageRowClass copyWith({
    int? kind,
    String? id,
    String? sig,
    String? tags,
    String? pubkey,
    String? content,
    String? sharedId,
    String? conversationId,
    DateTime? createdAt,
  }) {
    return EventMessageRowClass(
      id: id ?? this.id,
      sig: sig ?? this.sig,
      kind: kind ?? this.kind,
      tags: tags ?? this.tags,
      pubkey: pubkey ?? this.pubkey,
      content: content ?? this.content,
      sharedId: sharedId ?? this.sharedId,
      createdAt: createdAt ?? this.createdAt,
      conversationId: conversationId ?? this.conversationId,
    );
  }
}
