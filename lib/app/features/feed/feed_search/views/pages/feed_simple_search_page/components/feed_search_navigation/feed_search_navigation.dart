import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_history_provider.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/router/app_routes.dart';

class FeedSearchNavigation extends HookConsumerWidget {
  const FeedSearchNavigation({
    required this.query, required this.loading, super.key,
  });

  final String query;

  final bool loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final searchController = useTextEditingController();
    useOnInit(focusNode.requestFocus);

    useOnInit(() {
      // Sync query and text input value after setting a query from the history
      if (searchController.text != query) {
        searchController.text = query;
      }
    }, [query],);

    return ScreenSideOffset.small(
      child: Row(
        children: [
          Expanded(
            child: SearchInput(
              loading: loading,
              controller: searchController,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              onCancelSearch: () {
                context.pop();
              },
              onSubmitted: (String query) {
                context.pop();
                if (query.isNotEmpty) {
                  FeedAdvancedSearchRoute(query: query).go(context);
                  ref.read(feedSearchHistoryProvider.notifier).addQueryToTheHistory(query);
                }
              },
              onTextChanged: (String text) {
                if (query != text) {
                  FeedSimpleSearchRoute(query: text).replace(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
