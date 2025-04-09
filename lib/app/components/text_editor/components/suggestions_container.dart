// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/components/text_editor/components/cashtags_suggestions.dart';
import 'package:ion/app/components/text_editor/components/hashtags_suggestions.dart';
import 'package:ion/app/components/text_editor/components/mentions_suggestions.dart';
import 'package:ion/app/components/text_editor/components/suggestions_container_empty.dart';
import 'package:ion/app/components/text_editor/hooks/use_text_editor_suggestions.dart';
import 'package:ion/app/components/text_editor/text_editor.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/model/feature_flags.dart';
import 'package:ion/app/features/core/providers/feature_flags_provider.c.dart';

class SuggestionsContainer extends HookConsumerWidget {
  const SuggestionsContainer({
    required this.scrollController,
    required this.editorKey,
    required this.onMentionSuggestionSelected,
    super.key,
  });

  final ScrollController scrollController;
  final GlobalKey<TextEditorState> editorKey;
  final void Function(({String pubkey, String username})) onMentionSuggestionSelected;

  void _onSuggestionSelected(String suggestion) {
    final textEditorState = editorKey.currentState;
    textEditorState?.mentionsHashtagsHandler.onSuggestionSelected(suggestion);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestionsState = useTextEditorSuggestions(
      ref: ref,
      scrollController: scrollController,
      editorKey: editorKey,
    );

    final showSuggestions =
        ref.read(featureFlagsProvider.notifier).get(FeedFeatureFlag.showSuggestions);

    if (!showSuggestions || !suggestionsState.isVisible) {
      return const SizedBox.shrink();
    }

    if (suggestionsState.suggestions.isEmpty) {
      return const SuggestionsContainerEmpty();
    }

    return Column(
      children: [
        const HorizontalSeparator(),
        Container(
          height: 160.0.s,
          color: context.theme.appColors.secondaryBackground,
          child: switch (suggestionsState.taggingCharacter) {
            '@' => MentionsSuggestions(
                suggestions: suggestionsState.suggestions,
                onSuggestionSelected: (pubkeyUsernamePair) {
                  onMentionSuggestionSelected(pubkeyUsernamePair);
                  _onSuggestionSelected(pubkeyUsernamePair.username);
                },
              ),
            '#' => HashtagsSuggestions(
                suggestions: suggestionsState.suggestions,
                onSuggestionSelected: _onSuggestionSelected,
              ),
            r'$' => CashtagsSuggestions(
                suggestions: suggestionsState.suggestions,
                onSuggestionSelected: _onSuggestionSelected,
              ),
            _ => const SizedBox.shrink(),
          },
        ),
      ],
    );
  }
}
