// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/user/model/user_metadata.dart';
import 'package:widgetbook/widgetbook.dart';
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
        children: [
          Article(
            id: 'test_article_id',
            title: context.knobs.string(
              label: 'Title',
              initialValue: 'The volume of the BNB Chain network increased in May 65%',
            ),
            publishedAt: context.knobs.dateTime(
              label: 'Published at',
              initialValue: DateTime(2024, 2, 27, 11),
              start: DateTime(1970, 1, 1, 1),
              end: DateTime.now(),
            ),
            imageUrl: 'https://ice.io/wp-content/uploads/2023/03/Pre-Release-600x403.png',
            minutesToRead: context.knobs.int.input(
              label: 'Minutes to read',
              initialValue: 7,
            ),
            userMetadata: UserMetadata(
              name: context.knobs.string(
                label: 'Name',
                initialValue: 'Alina Proxima',
              ),
              displayName: context.knobs.string(
                label: 'Username',
                initialValue: 'alinaproxima',
              ),
              about: '',
              picture: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
              verified: true,
            ),
          ),
        ],
      ),
    ),
  );
}
