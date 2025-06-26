// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/suggestions/hashtags/hashtags_service.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hashtag_suggestions_provider.r.g.dart';

@riverpod
Future<List<String>> hashtagSuggestions(Ref ref, String query) async {
  if (query.isEmpty || !query.startsWith('#')) {
    return [];
  }

  final searchQuery = query.substring(1).toLowerCase();
  final service = await ref.watch(hashtagsServiceProvider.future);

  return service.getHashtags(searchQuery);
}
