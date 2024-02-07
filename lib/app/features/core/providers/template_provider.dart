import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:ice/app/templates/template.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_provider.g.dart';

Template? _template;

//TODO::discuss this approach
TemplateTheme get appTemplateTheme {
  return _template!.theme;
}

@riverpod
class TemplateLoading extends _$TemplateLoading {
  @override
  Future<Template> build() async {
    final String jsonString = await rootBundle.loadString('lib/app/templates/basic.json');
    return _template = Template.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }
}
