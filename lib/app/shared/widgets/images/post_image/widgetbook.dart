import 'package:flutter/material.dart';
import 'package:ice/app/shared/widgets/images/post_image/post_image.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'base case',
  type: PostImage,
)
Widget baseUseCase(BuildContext context) {
  return const PostImage(
    imageUrl:
        'https://ice.io/wp-content/uploads/2023/03/Pre-Release-600x403.png',
  );
}

@widgetbook.UseCase(
  name: 'with read time overlay',
  type: PostImage,
)
Widget withReadTimeUseCase(BuildContext context) {
  return const PostImage(
    imageUrl:
        'https://ice.io/wp-content/uploads/2023/03/Pre-Release-600x403.png',
    minutesToRead: 7,
    minutesToReadAlignment: Alignment.topRight,
  );
}
