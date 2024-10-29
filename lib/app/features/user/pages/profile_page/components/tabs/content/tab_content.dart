// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/user/model/user_content_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content/articles_tab.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content/posts_tab.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content/replies_tab.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content/videos_tab.dart';

class TabContent extends StatelessWidget {
  const TabContent({
    required this.pubkey,
    required this.tab,
    super.key,
  });

  final String pubkey;
  final UserContentType tab;

  @override
  Widget build(BuildContext context) {
    switch (tab) {
      case UserContentType.posts:
        return PostsTab(pubkey: pubkey);
      case UserContentType.replies:
        return RepliesTab(pubkey: pubkey);
      case UserContentType.videos:
        return VideosTab(pubkey: pubkey);
      case UserContentType.articles:
        return ArticlesTab(pubkey: pubkey);
    }
  }
}
