import 'package:flutter/material.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'feed post',
  type: Post,
)
Widget feedPostUseCase(BuildContext context) {
  return const Scaffold(
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Post(
          content: '''
⏰ We expect tomorrow to pre-release our ice app on Android.\n⏳ For iOS, we 
are still waiting on @Apple to approve our app. If, for some reason, Apple 
will not approve the app in time for 4th April, iOS users will be able to use 
a mobile web light version.\n\nAll the best, ice Team''',
        ),
      ],
    ),
  );
}
