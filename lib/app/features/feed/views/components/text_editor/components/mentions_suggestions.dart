// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/mention_item.dart';

const double mentionContainerPadding = 4;
const double mentionItemSize = 51;

class MentionsSuggestions extends StatelessWidget {
  const MentionsSuggestions({
    required this.suggestions,
    required this.onSuggestionSelected,
    super.key,
  });
  final List<String> suggestions;
  final ValueChanged<String> onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HorizontalSeparator(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: mentionContainerPadding),
            child: ListView.builder(
              itemCount: suggestions.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return SizedBox(
                  height: mentionItemSize,
                  child: Center(
                    child: ScreenSideOffset.small(
                      child: MentionItem(
                        pubkey: suggestion,
                        onPress: onSuggestionSelected,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
