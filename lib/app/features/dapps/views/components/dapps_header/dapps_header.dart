// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_button/navigation_button.dart';
import 'package:ion/generated/assets.gen.dart';

class DAppsHeader extends ConsumerWidget {
  const DAppsHeader({super.key});

  static double get height => 40.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height,
      child: ScreenSideOffset.small(
        child: Row(
          children: [
            NavigationButton(
              onPressed: context.pop,
              icon: IconAsset(
                Assets.svgIconBackArrow,
                colorFilter: ColorFilter.mode(context.theme.appColors.primaryText, BlendMode.srcIn),
                flipForRtl: true,
              ),
            ),
            SizedBox(width: 12.0.s),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => DAppsSimpleSearchRoute().push<void>(context),
                child: const IgnorePointer(
                  child: SearchInput(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 12.0.s),
              child: Button.icon(
                onPressed: () {
                  WalletsRoute().push<void>(context);
                },
                icon: const IconAsset(Assets.svgIconWallet),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
