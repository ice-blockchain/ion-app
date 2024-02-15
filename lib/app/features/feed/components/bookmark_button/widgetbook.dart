import 'package:flutter/material.dart';
import 'package:ice/app/features/feed/components/bookmark_button/bookmark_button.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'bookmark button',
  type: BookmarkButton,
)
Widget plainBookmarkButton(BuildContext context) {
  return const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      BookmarkButton(id: 'test_id'),
    ],
  );
}
