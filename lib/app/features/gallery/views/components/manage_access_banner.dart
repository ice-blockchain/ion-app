// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/app_info_provider.c.dart';
import 'package:ion/app/features/gallery/views/pages/media_picker_type.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ManageAccessBanner extends ConsumerWidget {
  const ManageAccessBanner({
    required this.type,
    super.key,
  });

  final MediaPickerType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Extract theme values to variables to avoid repeated theme calls
    final appColors = context.theme.appColors;
    final appTextThemes = context.theme.appTextThemes;
    final primaryAccent = appColors.primaryAccent;
    final appName = ref.watch(appInfoProvider).value?.appName ?? '';

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
              onPressed: () => ref.read(mediaServiceProvider).presentLimitedGallery(
                    type.toRequestType(),
                  ),
              type: ButtonType.outlined,
              tintColor: primaryAccent,
              leadingIcon: IconAssetColored(
                Assets.svgIconButtonManagecoin,
                color: primaryAccent,
                size: 16,
              ),
              label: Text(
                context.i18n.button_manage,
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
