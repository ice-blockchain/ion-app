// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';

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
    return Container(
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(maxHeight: 150),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            title: Text(suggestion),
            onTap: () => onSuggestionSelected(suggestion),
          );
        },
      ),
    );
  }
}
