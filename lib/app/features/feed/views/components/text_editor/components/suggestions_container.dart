// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/cashtags_suggestions.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/hashtags_suggestions.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/mentions_suggestions.dart';

class SuggestionsContainer extends ConsumerWidget {
  const SuggestionsContainer({
    required this.taggingCharacter,
    required this.suggestions,
    required this.onSuggestionSelected,
    super.key,
  });

  final String taggingCharacter;
  final List<String> suggestions;
  final void Function(String) onSuggestionSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 160.0.s,
      color: context.theme.appColors.secondaryBackground,
      child: switch (taggingCharacter) {
        '@' => MentionsSuggestions(
            suggestions: suggestions,
            onSuggestionSelected: onSuggestionSelected,
          ),
        '#' => HashtagsSuggestions(
            suggestions: suggestions,
            onSuggestionSelected: onSuggestionSelected,
          ),
        r'$' => CashtagsSuggestions(
            suggestions: suggestions,
            onSuggestionSelected: onSuggestionSelected,
          ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
