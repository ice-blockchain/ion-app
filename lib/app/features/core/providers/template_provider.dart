import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/core/providers/init_provider.dart';
import 'package:ice/app/templates/template.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_provider.g.dart';

TemplateTheme get appTemplateTheme => providerContainer.read(themeProvider);

@riverpod
class AppTemplate extends _$AppTemplate {
  @override
  Future<Template> build() => _fetch();

  Future<Template> _fetch() async {
    final String jsonString = await rootBundle.loadString('lib/app/templates/basic.json');
    final Template data = Template.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
    state = AsyncValue<Template>.data(data);
    _fillData(data);
    return data;
  }

  // ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
  void _fillData(Template template) {
    ref.read(pagesProvider.notifier)._savePages(template);
    ref.read(themeProvider.notifier)._saveTheme(template);
  }
}

@Riverpod(keepAlive: true)
class Theme extends _$Theme {
  @override
  TemplateTheme build() => TemplateTheme.empty();

  void _saveTheme(Template template) {
    state = template.theme;
  }
}

@Riverpod(keepAlive: true)
class Pages extends _$Pages {
  @override
  Map<String, TemplateConfigPage> build() => <String, TemplateConfigPage>{};

  void _savePages(Template template) {
    state.clear();
    final Map<String, TemplateConfigPage>? pages = template.config.pages;
    if (pages != null) {
      state.addAll(pages);
    }
  }
}

TemplateConfigPage? page(WidgetRef ref, String name) => ref.read(pagesProvider)[name];
