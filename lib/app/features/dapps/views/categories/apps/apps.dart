import 'package:flutter/material.dart';
import 'package:ice/app/components/section_header/section_header.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/dapps/views/components/apps_collection/apps_collection.dart';
import 'package:ice/app/features/dapps/views/pages/mocks/mocked_apps.dart';

class AppsRouteData {
  AppsRouteData({
    required this.title,
    this.items = const <DAppItem>[],
    this.isSearchVisible = true,
  });

  final String title;
  final List<DAppItem>? items;
  final bool? isSearchVisible;
}

class Apps extends StatelessWidget {
  const Apps({
    super.key,
    this.title = '',
    this.onPress,
    this.items,
    this.topOffset,
  });

  final String? title;
  final VoidCallback? onPress;
  final List<DAppItem>? items;
  final double? topOffset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topOffset ?? 6.0.s),
      child: Column(
        children: [
          SectionHeader(title: title, onPress: onPress),
          AppsCollection(items: items),
        ],
      ),
    );
  }
}
