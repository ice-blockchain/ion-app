// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/section_header/section_header.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/dapps/model/dapp_data.f.dart';
import 'package:ion/app/features/dapps/views/components/apps_collection/apps_collection.dart';

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
  final List<DAppData>? items;
  final double? topOffset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: topOffset ?? 6.0.s),
      child: Column(
        children: [
          SectionHeader(title: title, onPress: onPress),
          AppsCollection(items: items),
        ],
      ),
    );
  }
}
