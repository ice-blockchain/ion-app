import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/mocked_creators.dart';
import 'package:ice/app/features/feed/views/components/article/article.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'article',
  type: Article,
)
Widget feedPostUseCase(BuildContext context) {
  return Scaffold(
    body: ScreenSideOffset.small(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Article(
            id: 'test_article_id',
            title: 'The volume of the BNB Chain network increased in May 65%',
            publishedAt: DateTime(2024, 2, 27, 11),
            imageUrl:
                'https://ice.io/wp-content/uploads/2023/03/Pre-Release-600x403.png',
            minutesToRead: 7,
            user: const User(
              name: 'Alina Proxima',
              nickname: 'alinaproxima',
              imageUrl:
                  'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
              isVerified: true,
            ),
          ),
        ],
      ),
    ),
  );
}
