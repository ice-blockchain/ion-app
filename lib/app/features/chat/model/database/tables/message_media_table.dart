part of '../chat_database.c.dart';

class MessageMediaTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get status => intEnum<MessageMediaStatus>()();
  TextColumn get remoteUrl => text().nullable()();
  TextColumn get localPath => text().nullable()();
  TextColumn get eventMessageId => text().references(EventMessageTable, #id)();
}

enum MessageMediaStatus {
  created,
  processing,
  completed,
  failed,
}

class MediaFileConverter extends TypeConverter<MediaFile, String>
    with JsonTypeConverter2<MediaFile, String, Map<String, dynamic>> {
  const MediaFileConverter();

  @override
  MediaFile fromSql(String fromDb) {
    return fromJson(jsonDecode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(MediaFile value) {
    return jsonEncode(toJson(value));
  }

  @override
  MediaFile fromJson(Map<String, dynamic> json) {
    return MediaFile.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(MediaFile value) {
    return value.toJson();
  }
}
