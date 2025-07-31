// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/empty_list/empty_list.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';

class MessagingEmptyView extends StatelessWidget {
  const MessagingEmptyView({
    required this.title,
    required this.asset,
    this.trailing,
    this.leading,
    super.key,
  });

  final String title;
  final String asset;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.theme.appColors.primaryBackground,
      child: ScreenSideOffset.large(
        child: Column(
          children: [
            if (leading != null) leading!,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmptyList(
                    title: title,
                    asset: asset,
                    color: context.theme.appColors.onTerararyBackground,
                  ),
                  if (trailing != null) ...[
                    SizedBox(height: 10.0.s),
                    trailing!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
