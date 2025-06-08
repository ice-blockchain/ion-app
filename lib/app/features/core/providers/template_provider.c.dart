// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/data/models/template.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<Template> appTemplate(Ref ref) async {
  final jsonString = await rootBundle.loadString('lib/app/templates/basic.json');
  final data = Template.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  return data;
}

@riverpod
Map<String, TemplateConfigPage> pages(Ref ref) {
  final template = ref.watch(appTemplateProvider).unwrapPrevious().valueOrNull;
  return template?.config.pages ?? <String, TemplateConfigPage>{};
}

@riverpod
TemplateConfigPage? templateConfigPage(Ref ref, String pageName) {
  final pages = ref.watch(pagesProvider);
  return pages[pageName];
}
