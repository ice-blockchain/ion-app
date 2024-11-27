// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/empty_list/empty_list.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: EmptyList(
        asset: Assets.svg.walletIconProfileEmptyprofile,
        title: context.i18n.profile_empty_state,
      ),
    );
  }
}
