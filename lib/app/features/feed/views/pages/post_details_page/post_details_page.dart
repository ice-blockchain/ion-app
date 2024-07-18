import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_details_footer.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:ice/app/features/feed/views/components/post_list/components/post_list.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/generated/assets.gen.dart';

class PostDetailsPage extends StatelessWidget {
  const PostDetailsPage({
    required this.postData,
    super.key,
  });

  final PostData postData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: context.i18n.post_page_title,
        actions: [
          IconButton(
            icon: Assets.images.icons.iconBookmarks.icon(
              size: NavigationAppBar.actionButtonSide,
              color: context.theme.appColors.primaryText,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Post(
              postData: postData,
              footer: PostDetailsFooter(
                postData: postData,
              ),
            ),
          ),
          SliverToBoxAdapter(child: FeedListSeparator()),
          PostList(
            posts: List.generate(10, (_) => postData),
            separator: FeedListSeparator(height: 1.5.s),
          ),
        ],
      ),
    );
  }
}
