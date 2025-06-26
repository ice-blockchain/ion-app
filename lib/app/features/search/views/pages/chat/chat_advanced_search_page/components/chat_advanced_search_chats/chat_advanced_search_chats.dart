// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/search/providers/chat_messages_search_provider.r.dart';
import 'package:ion/app/features/search/views/pages/chat/components/chat_no_results_found.dart';
import 'package:ion/app/features/search/views/pages/chat/components/chat_search_results.dart';
import 'package:ion/app/features/search/views/pages/chat/components/chat_search_results_skeleton.dart';

class ChatAdvancedSearchChats extends HookConsumerWidget {
  const ChatAdvancedSearchChats({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final chatsSearchResults = ref.watch(chatMessagesSearchProvider(query));

    return chatsSearchResults.maybeWhen(
      data: (pubkeysAndContentTuples) {
        if (pubkeysAndContentTuples!.isEmpty) {
          return const ChatSearchNoResults();
        } else {
          return ChatSearchResults(pubkeysAndContentTuples: pubkeysAndContentTuples);
        }
      },
      orElse: ChatSearchResultsSkeleton.new,
    );
  }
}
