// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/section_header/section_header.dart';
import 'package:ice/app/features/dapps/model/dapp_data.dart';
import 'package:ice/app/features/dapps/views/components/apps_collection/apps_collection.dart';

class AppsRouteData {
  AppsRouteData({
    required this.title,
    this.items = const <DAppData>[],
    this.isSearchVisible = false,
  });

  final String title;
  final List<DAppData>? items;
  final bool? isSearchVisible;
}

class Apps extends StatelessWidget {
  const Apps({
    super.key,
    this.title = '',
    this.onPress,
    this.items,
  });

  final String? title;
  final VoidCallback? onPress;
  final List<DAppData>? items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(title: title, onPress: onPress),
        AppsCollection(items: items),
      ],
    );
  }
}
