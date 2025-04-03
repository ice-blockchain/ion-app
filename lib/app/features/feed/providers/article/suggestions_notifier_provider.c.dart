// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/article/cashtag_suggestions_provider.c.dart';
import 'package:ion/app/features/feed/providers/article/hashtag_suggestions_provider.c.dart';
import 'package:ion/app/features/feed/providers/article/mention_suggestions_provider.c.dart';
import 'package:ion/app/services/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'suggestions_notifier_provider.c.g.dart';

class SuggestionsState {
  const SuggestionsState({
    this.suggestions = const [],
    this.taggingCharacter = '',
    this.isVisible = false,
  });

  final List<String> suggestions;
  final String taggingCharacter;
  final bool isVisible;
}

@riverpod
class SuggestionsNotifier extends _$SuggestionsNotifier {
  String _currentQuery = '';

  @override
  SuggestionsState build() {
    return const SuggestionsState();
  }

  Future<void> updateSuggestions(String query, String taggingCharacter) async {
    if (query.isEmpty) {
      ref.invalidate(suggestionsNotifierProvider);
      return;
    }

    _currentQuery = query;
    await ref.debounce();
    if (_currentQuery != query) {
      return;
    }

    try {
      final suggestions = switch (taggingCharacter) {
        '#' => await ref.read(hashtagSuggestionsProvider(query).future),
        '@' => await ref.read(mentionSuggestionsProvider(query).future),
        r'$' => await ref.read(cashtagSuggestionsProvider(query).future),
        _ => <String>[],
      };

      state = SuggestionsState(
        suggestions: suggestions,
        taggingCharacter: taggingCharacter,
        isVisible: true,
      );
    } catch (error) {
      Logger.log('Error fetching suggestions: $error');
      state = const SuggestionsState();
    }
  }
}
