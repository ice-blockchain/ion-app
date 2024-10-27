// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
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

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: hashtagContainerPadding),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height / 2,
        ),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: suggestions.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            return ScreenSideOffset.small(
              child: SizedBox(
                height: hashtagItemSize,
                child: Text(
                  suggestion,
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.primaryText,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
