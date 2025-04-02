// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';

class CashtagsSuggestions extends StatelessWidget {
  const CashtagsSuggestions({
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
            padding: EdgeInsets.symmetric(vertical: 5.0.s),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: suggestions.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return GestureDetector(
                  onTap: () => onSuggestionSelected(suggestion),
                  child: ScreenSideOffset.small(
                    child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      height: 30.0.s,
                      child: DefaultTextStyle(
                        style: context.theme.appTextThemes.caption.copyWith(
                          color: context.theme.appColors.primaryText,
                        ),
                        child: Text(suggestion),
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
