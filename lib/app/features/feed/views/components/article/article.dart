import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/mocked_creators.dart';
import 'package:ice/app/features/feed/views/components/article/components/article_header/article_header.dart';
import 'package:ice/app/features/feed/views/components/article/components/article_image/article_image.dart';
import 'package:ice/app/features/feed/views/components/article/components/bookmark_button/bookmark_button.dart';

class Article extends StatelessWidget {
  const Article({
    required this.id,
    required this.user,
    required this.publishedAt,
    required this.imageUrl,
    required this.minutesToRead,
    required this.title,
    super.key,
  });

  final String id;

  final User user;

  final DateTime publishedAt;

  final String imageUrl;

  final int minutesToRead;

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListItem.user(
          title: Text(user.name),
          subtitle: Text(user.nickname),
          profilePicture: user.imageUrl,
          verifiedBadge: user.isVerified.falseOrValue,
          timeago: publishedAt,
          onTap: () {},
          trailing: const BookmarkButton(id: 'test_article_id'),
        ),
        SizedBox(height: 10.0.s),
        ArticleImage(
          imageUrl: imageUrl,
          minutesToRead: minutesToRead,
        ),
        SizedBox(height: 16.0.s),
        ArticleHeader(text: title),
      ],
    );
  }
}
