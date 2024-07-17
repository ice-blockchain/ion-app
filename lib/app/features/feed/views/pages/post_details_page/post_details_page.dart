import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_details_footer.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/post_list/components/post_list.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/generated/assets.gen.dart';

final postData = PostData.fromRawContent(
  id: 'test_1',
  rawContent: '''
⏰ We expect tomorrow to pre-release our ice app on Android.\n⏳ For iOS, we 
are still waiting on @Apple to approve our app. If, for some reason, Apple 
will not approve the app in time for 4th April, iOS users will be able to use 
a mobile web light version.\n\nAll the best, ice Team
                ''',
);

class PostDetailsPage extends StatelessWidget {
  const PostDetailsPage({super.key});

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
          PostList(
            posts: List.generate(10, (_) => postData),
          ),
        ],
      ),
    );
  }
}
