import 'package:flutter/material.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'regular',
  type: Avatar,
)
Widget regularButtonUseCase(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Avatar(
          size: UiSize.large,
          imageUrl:
              'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
        ),
      ],
    ),
  );
}
