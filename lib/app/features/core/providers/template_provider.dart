import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_provider.g.dart';

@riverpod
Future<Map<String, Object?>> template(TemplateRef ref) async {
  final String jsonString =
      await rootBundle.loadString('lib/app/templates/basic.json');
  return jsonDecode(jsonString) as Map<String, Object?>;
}
