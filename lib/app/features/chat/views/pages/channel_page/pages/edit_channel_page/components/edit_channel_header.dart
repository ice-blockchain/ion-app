// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/generated/assets.gen.dart';

class EditChannelHeader extends StatelessWidget {
  const EditChannelHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTopOffset(
      child: ScreenSideOffset.small(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              assetName: Assets.svg.iconProfileBack,
              opacity: 1,
            ),
            const Spacer(),
            HeaderAction(
              onPressed: () {},
              assetName: Assets.svg.iconMorePopup,
              opacity: 1,
            ),
          ],
        ),
      ),
    );
  }
}
