// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/article/suggestions_notifier_provider.c.dart';

class TextEditorSuggestionsState {
  const TextEditorSuggestionsState({
    required this.isVisible,
    required this.suggestions,
    required this.taggingCharacter,
  });

  final bool isVisible;
  final List<String> suggestions;
  final String taggingCharacter;
}

TextEditorSuggestionsState useTextEditorSuggestions({
  required ScrollController scrollController,
  required GlobalKey<State<StatefulWidget>> editorKey,
  required WidgetRef ref,
}) {
  final suggestionsState = ref.watch(suggestionsNotifierProvider);

  useEffect(
    () {
      if (suggestionsState.isVisible) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
      return null;
    },
    [suggestionsState.isVisible],
  );

  useEffect(
    () {
      void onTextChange() {
        if (scrollController.hasClients) {
          final editorContext = editorKey.currentContext;
          if (editorContext != null) {
            Scrollable.ensureVisible(
              editorContext,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
            );
          }
        }
      }

      return onTextChange;
    },
    [],
  );

  return TextEditorSuggestionsState(
    isVisible: suggestionsState.isVisible,
    suggestions: suggestionsState.suggestions,
    taggingCharacter: suggestionsState.taggingCharacter,
  );
}
