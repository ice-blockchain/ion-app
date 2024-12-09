// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/article/mocked_pubkeys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mention_suggestions_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<List<String>> mentionSuggestions(Ref ref, String query) async {
  if (query.isEmpty || !query.startsWith('@')) {
    return [];
  }
  await ref.debounce();
  await Future<void>.delayed(const Duration(milliseconds: 500));

  final random = Random();
  final randomKeys = <String>{};
  while (randomKeys.length < 6) {
    randomKeys.add(pubKeys[random.nextInt(pubKeys.length)]);
  }

  return randomKeys.toList();
}
