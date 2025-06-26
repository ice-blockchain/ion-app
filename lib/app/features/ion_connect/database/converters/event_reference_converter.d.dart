// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';

class EventReferenceConverter extends TypeConverter<EventReference, String>
    with JsonTypeConverter2<EventReference, String, List<String>> {
  const EventReferenceConverter();

  @override
  EventReference fromSql(String fromDb) {
    return fromJson(jsonDecode(fromDb) as List<dynamic>);
  }

  @override
  String toSql(EventReference value) {
    return jsonEncode(toJson(value));
  }

  @override
  EventReference fromJson(List<dynamic> json) {
    return EventReference.fromTag(List<String>.from(json));
  }

  @override
  List<String> toJson(EventReference value) {
    return value.toTag();
  }
}
