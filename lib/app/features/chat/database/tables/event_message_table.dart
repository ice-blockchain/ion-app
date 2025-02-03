part of '../chat_database.c.dart';

// class EventMessageTable extends Table {
//   TextColumn get eventId => text()();
//   TextColumn get eventMessage => text().map(const EventMessageConverter())();

//   @override
//   Set<Column<Object>> get primaryKey => {eventId};
// }

// class EventMessageConverter extends TypeConverter<EventMessage, String>
//     with JsonTypeConverter2<EventMessage, String, List<dynamic>> {
//   const EventMessageConverter();

//   @override
//   EventMessage fromSql(String fromDb) {
//     return EventMessage.fromPayloadJson(jsonDecode(fromDb) as Map<String, dynamic>);
//   }

//   @override
//   String toSql(EventMessage value) => jsonEncode(value.toJson());

//   @override
//   EventMessage fromJson(List<dynamic> json) {
//     return EventMessage.fromJson(json);
//   }

//   @override
//   List<dynamic> toJson(EventMessage value) => value.toJson();
// }

@UseRowClass(EventMessageRowClass)
class EventMessageTable extends Table {
  TextColumn get id => text()();
  TextColumn get sig => text().nullable()();
  TextColumn get tags => text()();
  TextColumn get pubkey => text()();
  IntColumn get kind => integer()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();

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
      createdAt: createdAt ?? this.createdAt,
      conversationId: conversationId ?? this.conversationId,
    );
  }
}
