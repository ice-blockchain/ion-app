// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/model/chat_search_result_item.f.dart';
import 'package:ion/app/features/search/views/pages/chat/components/chat_search_results_list_item.dart';

class ChatSearchResults extends ConsumerWidget {
  const ChatSearchResults({
    required this.searchResults,
    this.showLastMessage = true,
    super.key,
  });

  final bool showLastMessage;
  final List<ChatSearchResultItem> searchResults;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      itemCount: searchResults.length,
      padding: EdgeInsets.symmetric(vertical: 16.0.s),
      separatorBuilder: (_, __) => const HorizontalSeparator(),
      itemBuilder: (context, index) => ChatSearchResultListItem(
        showLastMessage: showLastMessage,
        item: searchResults[index],
      ),
    );
  }
}
