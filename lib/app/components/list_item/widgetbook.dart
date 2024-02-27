import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'regular',
  type: ListItem,
)
Widget regularListItemUseCase(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ListItem(
          title: const Text('Simple'),
          subtitle: const Text('List Item'),
          backgroundColor: context.theme.appColors.primaryBackground,
        ),
        ListItem(
          title: const Text('With On Tap'),
          subtitle: const Text('List Item'),
          onTap: () {},
          backgroundColor: context.theme.appColors.primaryBackground,
        ),
        ListItem.checkbox(
          value: true,
          title: const Text('With On Tap'),
          subtitle: const Text('List Item!!'),
          onTap: () {},
        ),
      ],
    ),
  );
}
