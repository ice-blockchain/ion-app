// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/views/pages/chat_simple_search_page/components/search_results/chat_search_results_list_item.dart';

class ChatSimpleSearchResults extends ConsumerWidget {
  const ChatSimpleSearchResults({
    required this.pubkeysAndContentMap,
    super.key,
  });

  final Map<String, String> pubkeysAndContentMap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flexible(
      child: ListView.builder(
        itemCount: pubkeysAndContentMap.length,
        padding: EdgeInsets.symmetric(vertical: 16.0.s),
        itemBuilder: (context, index) => ChatSimpleSearchResultListItem(
          pubkeyAndContent: pubkeysAndContentMap.entries.elementAt(index),
        ),
      ),
    );
  }
}
