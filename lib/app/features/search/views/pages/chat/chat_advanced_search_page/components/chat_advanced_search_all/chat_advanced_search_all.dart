// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/search/providers/chat_full_search_provider.c.dart';
import 'package:ion/app/features/search/views/components/search_results_skeleton/search_results_skeleton.dart';
import 'package:ion/app/features/search/views/pages/chat/components/chat_no_results_found.dart';
import 'package:ion/app/features/search/views/pages/chat/components/chat_search_results.dart';

class ChatAdvancedSearchAll extends HookConsumerWidget {
  const ChatAdvancedSearchAll({required this.query, super.key});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final chatsSearchResults = ref.watch(chatFullSearchProvider(query));

    return chatsSearchResults.maybeWhen(
      data: (pubkeysAndContentTuples) {
        if (pubkeysAndContentTuples!.isEmpty) {
          return const ChatSearchNoResults();
        } else {
          return ChatSearchResults(pubkeysAndContentTuples: pubkeysAndContentTuples);
        }
      },
      orElse: SearchResultsSkeleton.new,
    );
  }
}
