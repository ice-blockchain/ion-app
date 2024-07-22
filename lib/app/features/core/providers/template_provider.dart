import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:ice/app/templates/template.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Template> appTemplate(AppTemplateRef ref) async {
  final jsonString = await rootBundle.loadString('lib/app/templates/basic.json');
  final data = Template.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  return data;
}

@riverpod
Map<String, TemplateConfigPage> pages(PagesRef ref) {
  final template = ref.watch(appTemplateProvider).unwrapPrevious().valueOrNull;
  return template?.config.pages ?? <String, TemplateConfigPage>{};
}

@riverpod
TemplateConfigPage? templateConfigPage(
  TemplateConfigPageRef ref,
  String pageName,
) {
  final pages = ref.watch(pagesProvider);
  return pages[pageName];
}
