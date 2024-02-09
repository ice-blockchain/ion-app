import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/templates/template.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_provider.g.dart';

//TODO::remove alongside with usages
Template? _template;

Template get appTemplate {
  return _template!;
}

@riverpod
class AppTemplate extends _$AppTemplate {
  @override
  Future<Template> build() => _fetch();

  Future<Template> _fetch() async {
    final String jsonString = await rootBundle.loadString('lib/app/templates/basic.json');
    final Template data = Template.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    state = AsyncValue<Template>.data(data);
// ignore: avoid_manual_providers_as_generated_provider_dependency
    ref.read(pagesProvider.notifier)._savePages(data);
    return _template = data;
  }
}

@Riverpod(keepAlive: true)
class Pages extends _$Pages {
  @override
  Map<String, TemplateConfigPage> build() {
    return <String, TemplateConfigPage>{};
  }

  void _savePages(Template template) {
    state.clear();
    final Map<String, TemplateConfigPage>? pages = template.config.pages;
    if (pages != null) {
      state.addAll(pages);
    }
  }
}

TemplateConfigPage? page(WidgetRef ref, String name) => ref.read(pagesProvider)[name];
