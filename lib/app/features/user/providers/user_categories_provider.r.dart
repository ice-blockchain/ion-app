// SPDX-License-Identifier: ice License 1.0

import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/providers/app_locale_provider.r.dart';
import 'package:ion/app/features/user/model/user_category.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_categories_provider.r.g.dart';

@Riverpod(keepAlive: true)
Future<Map<String, UserCategory>?> userCategories(Ref ref) async {
  final appLocale = ref.watch(appLocaleProvider);
  //TODO:replace with a real req when impl
  final response = await _fetchCategories(appLocale.languageCode);
  final jsonList = jsonDecode(response) as List<dynamic>;
  final categories =
      jsonList.map((categoryJson) => UserCategory.fromJson(categoryJson as Map<String, dynamic>));
  return {for (final category in categories) category.key: category};
}

Future<String> _fetchCategories(String localeCode) async {
  await Future<void>.delayed(const Duration(milliseconds: 500));
  return '[{"key":"aviation","name":"Aviation"},{"key":"blockchain","name":"Blockchain"},{"key":"business","name":"Business"},{"key":"cars","name":"Cars"},{"key":"cryptocurrency","name":"Cryptocurrency"},{"key":"dataScience","name":"Data Science"},{"key":"education","name":"Education"},{"key":"finance","name":"Finance"},{"key":"gamer","name":"Gamer"},{"key":"style","name":"Style"},{"key":"restaurant","name":"Restaurant"},{"key":"trading","name":"Trading"},{"key":"technology","name":"Technology"},{"key":"traveler","name":"Traveler"},{"key":"news","name":"News"}]';
}
