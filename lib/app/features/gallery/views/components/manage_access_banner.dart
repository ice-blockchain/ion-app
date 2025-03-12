// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ManageAccessBanner extends ConsumerWidget {
  const ManageAccessBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Extract theme values to variables to avoid repeated theme calls
    final appColors = context.theme.appColors;
    final appTextThemes = context.theme.appTextThemes;
    final primaryAccent = appColors.primaryAccent;

    return ColoredBox(
      color: appColors.tertararyBackground,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0.s,
          horizontal: 16.0.s,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                context.i18n.gallery_access_description(appName),
                style: appTextThemes.caption2,
              ),
            ),
            Button(
              onPressed: ref.read(permissionStrategyProvider(Permission.photos)).openSettings,
              type: ButtonType.outlined,
              tintColor: primaryAccent,
              leadingIcon: Assets.svg.iconButtonManagecoin.icon(
                color: primaryAccent,
                size: 16.0.s,
              ),
              label: Text(
                context.i18n.gallery_manage,
                style: appTextThemes.caption.copyWith(
                  color: primaryAccent,
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(87.0.s, 28.0.s),
                padding: EdgeInsets.symmetric(horizontal: 15.0.s),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
