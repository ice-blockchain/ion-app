import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:ice/app/templates/template.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_provider.g.dart';

late Template _template;

//TODO::discuss this approach
Template get appTemplate {
  return _template;
}

@Riverpod(keepAlive: true)
Future<Template> template(TemplateRef ref) async {
  final String jsonString =
      await rootBundle.loadString('lib/app/templates/basic.json');
  return _template =
      Template.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
}
