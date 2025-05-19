// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

class StringOrIntConverter implements JsonConverter<String, dynamic> {
  const StringOrIntConverter();

  @override
  String fromJson(dynamic json) {
    if (json is String) {
      return json;
    } else if (json is int) {
      return json.toString();
    }
    return '';
  }

  @override
  dynamic toJson(String value) {
    return value;
  }
}
