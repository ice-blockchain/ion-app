import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/templates/template.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_provider.g.dart';

late TemplateTheme _templateTheme;

TemplateTheme get appTemplateTheme => _templateTheme;

@Riverpod(keepAlive: true)
class AppTemplate extends _$AppTemplate {
  @override
  Future<Template> build() => _fetch();

  Future<Template> _fetch() async {
    final String jsonString =
        await rootBundle.loadString('lib/app/templates/basic.json');
    final Template data =
        Template.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    state = AsyncValue<Template>.data(data);
    _fillData(data);

    return data;
  }

  // ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
  void _fillData(Template template) {
    ref.read(pagesProvider.notifier)._savePages(template);
    _templateTheme = template.theme;
  }
}

@Riverpod(keepAlive: true)
class Pages extends _$Pages {
  @override
  Map<String, TemplateConfigPage> build() => <String, TemplateConfigPage>{};

  void _savePages(Template template) {
    final Map<String, TemplateConfigPage>? pages = template.config.pages;
    if (pages != null) {
      state = pages;
    }
  }
}

TemplateConfigPage? page(WidgetRef ref, String name) =>
    ref.read(pagesProvider)[name];
