import 'package:flutter/material.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';
import 'package:ice/app/features/dapps/views/pages/widgets/apps_collection.dart';
import 'package:ice/app/shared/widgets/section_header/section_header.dart';

class Apps extends StatelessWidget {
  const Apps({
    this.title = '',
    this.onPress,
    this.items,
  });

  final String? title;
  final VoidCallback? onPress;
  final List<DAppItem>? items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SectionHeader(title: title, onPress: onPress),
        AppsCollection(items: items),
      ],
    );
  }
}
