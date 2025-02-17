// SPDX-License-Identifier: ice License 1.0

import 'package:freezed_annotation/freezed_annotation.dart';

class NumberToStringConverter implements JsonConverter<String, dynamic> {
  const NumberToStringConverter();

  @override
  String fromJson(dynamic json) => json == null ? '0' : json.toString();

  @override
  dynamic toJson(String object) => object;
}
