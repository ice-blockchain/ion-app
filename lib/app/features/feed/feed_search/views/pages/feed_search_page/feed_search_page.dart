import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/model/feed_search_user.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_history_provider.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_simple_search_results.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_search_page/components/feed_search_navigation.dart';
import 'package:ice/app/utils/username.dart';
import 'package:ice/generated/assets.gen.dart';

class FeedSearchPage extends ConsumerWidget {
  const FeedSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(feedSearchHistoryProvider);
    final searchResults = ref.watch(feedSimpleSearchResultsProvider);
    print(searchResults);

    return Scaffold(
      body: ScreenTopOffset(
        child: Column(
          children: [
            FeedSearchNavigation(),
            searchResults.maybeWhen(
              data: (searchResultsData) {
                return searchResultsData == null
                    ? history.maybeWhen(
                        data: (historyData) => FeedSearchEmpty(),
                        orElse: () => SizedBox.shrink(),
                      )
                    : FeedSearchResults(users: searchResultsData);
              },
              orElse: () => SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedSearchResults extends StatelessWidget {
  const FeedSearchResults({
    super.key,
    required this.users,
  });

  final List<FeedSearchUser> users;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0.s),
        child: ListView.separated(
          itemCount: users.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.0.s),
          itemBuilder: (context, index) {
            final user = users[index];
            return ScreenSideOffset.small(
              child: ListItem.user(
                title: Text(user.name),
                subtitle: Text(prefixUsername(username: user.nickname, context: context)),
                profilePicture: user.imageUrl,
                verifiedBadge: user.isVerified ?? false,
              ),
            );
          },
        ),
      ),
    );
  }
}

class FeedSearchEmpty extends StatelessWidget {
  const FeedSearchEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScreenSideOffset.small(
        child: Column(
          children: [
            SizedBox(height: 150.0.s),
            Assets.svg.walletIconWalletSearching.icon(size: 48.0.s),
            SizedBox(height: 8.0.s),
            Text(
              context.i18n.feed_search_empty,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.tertararyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
