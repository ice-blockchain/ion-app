import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/feed_search/model/feed_search_user.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_history_store_provider.dart';
import 'package:ice/app/utils/username.dart';

class FeedSearchResults extends ConsumerWidget {
  const FeedSearchResults({
    super.key,
    required this.users,
  });

  static double get listVerticalOffset => 14.0.s;

  static double get itemVerticalOffset => 8.0.s;

  final List<FeedSearchUser> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: listVerticalOffset),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              ref.read(feedSearchHistoryStoreProvider.notifier).addUserIdToTheHistory(user.id);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: itemVerticalOffset),
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
