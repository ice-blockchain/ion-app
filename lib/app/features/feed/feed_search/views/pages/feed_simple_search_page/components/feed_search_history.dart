import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/model/feed_search_user.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_history_store_provider.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_query_provider.dart';
import 'package:ice/app/utils/username.dart';
import 'package:ice/generated/assets.gen.dart';

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
          _HistoryHeader(),
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
                  itemBuilder: (context, index) => _HistoryUserListItem(user: users[index]),
                ),
              ),
            ),
          if (queries.isNotEmpty)
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.0.s),
                itemCount: queries.length,
                itemBuilder: (context, index) => _HistoryQueryListItem(query: queries[index]),
              ),
            )
        ],
      ),
    );
  }
}

class _HistoryHeader extends ConsumerWidget {
  const _HistoryHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
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
          onTap: () {
            ref.read(feedSearchHistoryStoreProvider.notifier).clear();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenSideOffset.defaultSmallMargin),
            child: Assets.svg.iconSheetClose.icon(size: 20.0.s),
          ),
        )
      ],
    );
  }
}

class _HistoryUserListItem extends StatelessWidget {
  const _HistoryUserListItem({required this.user});

  final FeedSearchUser user;

  @override
  Widget build(BuildContext context) {
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
  }
}

class _HistoryQueryListItem extends ConsumerWidget {
  const _HistoryQueryListItem({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(feedSearchQueryControllerProvider.notifier).update(query: query);
      },
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
  }
}
