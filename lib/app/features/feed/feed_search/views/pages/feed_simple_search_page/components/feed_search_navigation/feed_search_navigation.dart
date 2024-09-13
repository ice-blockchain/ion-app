import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_history_store_provider.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_query_provider.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_simple_search_page/hooks/use_go_back_on_blur.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/router/app_routes.dart';

class FeedSearchNavigation extends HookConsumerWidget {
  const FeedSearchNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final searchController = useTextEditingController();
    useOnInit(focusNode.requestFocus);
    useGoBackOnBlur(focusNode: focusNode);

    ref.listen(feedSearchQueryControllerProvider, (_, value) {
      if (searchController.text != value) {
        searchController.text = value;
      }
    });

    return ScreenSideOffset.small(
      child: Row(
        children: [
          Expanded(
            child: SearchInput(
              controller: searchController,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: (String query) {
                if (query.isNotEmpty) {
                  FeedAdvancedSearchRoute(query: query).go(context);
                  ref.read(feedSearchHistoryStoreProvider.notifier).addQueryToTheHistory(query);
                }
              },
              onTextChanged: (String query) {
                ref.read(feedSearchQueryControllerProvider.notifier).update(query: query);
              },
            ),
          ),
        ],
      ),
    );
  }
}
