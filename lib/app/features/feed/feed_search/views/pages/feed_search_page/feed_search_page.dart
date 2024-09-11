import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/avatar/avatar.dart';
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
                        data: (historyData) =>
                            historyData.users.isEmpty && historyData.queries.isEmpty
                                ? FeedSearchEmptyHistory()
                                : FeedSearchHistory(
                                    users: historyData.users, queries: historyData.queries),
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

class FeedSearchResults extends ConsumerWidget {
  const FeedSearchResults({
    super.key,
    required this.users,
  });

  final List<FeedSearchUser> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 14.0.s),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return GestureDetector(
            onTap: () {
              ref.read(feedSearchHistoryProvider.notifier).addUserToTheHistory(user);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0.s),
              child: ScreenSideOffset.small(
                child: ListItem.user(
                  title: Text(user.name),
                  subtitle: Text(prefixUsername(username: user.nickname, context: context)),
                  profilePicture: user.imageUrl,
                  verifiedBadge: user.isVerified,
                  ntfAvatar: user.nft,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FeedSearchEmptyHistory extends StatelessWidget {
  const FeedSearchEmptyHistory({super.key});

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

class FeedSearchHistory extends StatelessWidget {
  const FeedSearchHistory({
    super.key,
    required this.users,
    required this.queries,
  });

  final List<FeedSearchUser> users;

  final List<String> queries;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          SizedBox(height: 20.0.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: ScreenSideOffset.defaultSmallMargin),
                child: Text(
                  context.i18n.feed_search_history_title,
                  style: context.theme.appTextThemes.subtitle3.copyWith(
                    color: context.theme.appColors.quaternaryText,
                  ),
                ),
              ),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
                  child: Assets.svg.iconSheetClose.icon(size: 20.0.s),
                ),
              )
            ],
          ),
          if (users.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 16.0.s),
              child: SizedBox(
                height: 105.0.s,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length,
                  separatorBuilder: (context, index) => SizedBox(width: 12.0.s),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return SizedBox(
                      width: 65.0.s,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Avatar(size: 65.0.s, imageUrl: user.imageUrl, hexagon: user.nft),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                user.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.theme.appTextThemes.caption3.copyWith(
                                  color: context.theme.appColors.primaryText,
                                ),
                              ),
                              Text(
                                prefixUsername(username: user.nickname, context: context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.theme.appTextThemes.caption3.copyWith(
                                  color: context.theme.appColors.tertararyText,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          if (queries.isNotEmpty)
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.0.s),
                itemCount: queries.length,
                itemBuilder: (context, index) {
                  final query = queries[index];
                  return GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0.s,
                        horizontal: ScreenSideOffset.defaultSmallMargin,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            query,
                            style: context.theme.appTextThemes.body2.copyWith(
                              color: context.theme.appColors.primaryText,
                            ),
                          ),
                          Assets.svg.iconSearchHistorylink.icon(size: 20.0.s),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
