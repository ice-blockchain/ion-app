import 'package:flutter/material.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/components/post/components/post_body/post_body.dart';
import 'package:ice/app/features/feed/components/post/components/post_footer/post_footer.dart';
import 'package:ice/app/features/feed/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/components/post/components/post_header/post_menu.dart';

class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0.s),
      child: const Column(
        children: <Widget>[
          PostHeader(
            trailing: PostMenu(),
          ),
          PostBody(
            content:
                '⏰ We expect tomorrow to pre-release our ice app on Android.\n⏳ For iOS, we are still waiting on @Apple to approve our app. If, for some reason, Apple will not approve the app in time for 4th April, iOS users will be able to use a mobile web light version.\n\nAll the best, ice Team',
          ),
          PostFooter(),
        ],
      ),
    );
  }
}
