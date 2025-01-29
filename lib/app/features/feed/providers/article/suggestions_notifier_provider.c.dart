// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/features/feed/providers/article/cashtag_suggestions_provider.c.dart';
import 'package:ion/app/features/feed/providers/article/hashtag_suggestions_provider.c.dart';
import 'package:ion/app/features/feed/providers/article/mention_suggestions_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'suggestions_notifier_provider.c.g.dart';

@riverpod
class SuggestionsNotifier extends _$SuggestionsNotifier {
  @override
  List<String> build() {
    return [];
  }

  Future<void> updateSuggestions(String query, String taggingCharacter) async {
    var newSuggestions = <String>[];

    if (query.isEmpty) {
      state = [];
    } else {
      try {
        if (taggingCharacter == '#') {
          newSuggestions = await ref.read(hashtagSuggestionsProvider(query).future);
        } else if (taggingCharacter == '@') {
          newSuggestions = await ref.read(mentionSuggestionsProvider(query).future);
        } else if (taggingCharacter == r'$') {
          newSuggestions = await ref.read(cashtagSuggestionsProvider(query).future);
        }
      } catch (error) {
        Logger.log('Error fetching suggestions: $error');
      }

      state = newSuggestions;
    }
  }
}
