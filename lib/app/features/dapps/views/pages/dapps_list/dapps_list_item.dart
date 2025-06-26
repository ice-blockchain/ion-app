// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/dapps/model/dapp_data.f.dart';
import 'package:ion/app/features/dapps/views/components/grid_item/grid_item.dart';

class DAppsListItem extends StatelessWidget {
  const DAppsListItem({
    required this.app,
    super.key,
  });

  final DAppData app;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5.5.s,
      ),
      child: GridItem(
        dAppData: app,
        showIsFavourite: true,
      ),
    );
  }
}
