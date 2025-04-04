// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/article/mocked_hashtags.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hashtag_suggestions_provider.c.g.dart';

@riverpod
Future<List<String>> hashtagSuggestions(Ref ref, String query) async {
  if (query.isEmpty || !query.startsWith('#')) {
    return [];
  }

  // TODO: Replace mocked hashtags with real hashtags
  await Future<void>.delayed(const Duration(milliseconds: 300));
  final filteredHashtags =
      hashtags.where((hashtag) => hashtag.toLowerCase().contains(query.toLowerCase())).toList();

  return filteredHashtags;
}
