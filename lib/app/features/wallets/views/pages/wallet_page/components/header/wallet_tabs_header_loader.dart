// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';

class WalletTabsHeaderLoader extends StatelessWidget {
  const WalletTabsHeaderLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Column(
        children: [
          SizedBox(height: 8.0.s),
          SkeletonBox(height: 40.0.s),
          SizedBox(height: 2.0.s),
        ],
      ),
    );
  }
}
