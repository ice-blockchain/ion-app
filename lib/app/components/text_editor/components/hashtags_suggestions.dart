// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';

const double hashtagContainerPadding = 5;
const double hashtagItemSize = 30;

class HashtagsSuggestions extends StatelessWidget {
  const HashtagsSuggestions({
    required this.suggestions,
    required this.onSuggestionSelected,
    super.key,
  });

  final List<String> suggestions;
  final ValueChanged<String> onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const HorizontalSeparator(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: hashtagContainerPadding),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: suggestions.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return GestureDetector(
                  onTap: () => onSuggestionSelected(suggestion),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    alignment: AlignmentDirectional.centerStart,
                    height: hashtagItemSize,
                    child: DefaultTextStyle(
                      style: context.theme.appTextThemes.caption.copyWith(
                        color: context.theme.appColors.primaryText,
                      ),
                      child: Text(
                        suggestion,
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
