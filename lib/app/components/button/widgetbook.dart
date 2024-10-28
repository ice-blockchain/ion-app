// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ice_loading_indicator.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'regular',
  type: Button,
)
Widget regularButtonUseCase(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Button(
          label: Text(
            context.knobs.string(
              label: 'Label',
              initialValue: 'Default',
            ),
          ),
          mainAxisSize: MainAxisSize.max,
          leadingIcon: Assets.svg.iconBookmarks.icon(),
          onPressed: () {},
        ),
        Button(
          type: ButtonType.secondary,
          label: const Text('Secondary'),
          mainAxisSize: MainAxisSize.max,
          trailingIcon: Assets.svg.iconBookmarks.icon(),
          onPressed: () {},
        ),
        Button(
          type: ButtonType.outlined,
          label: const Text('Outlined'),
          mainAxisSize: MainAxisSize.max,
          leadingIcon: Assets.svg.iconBookmarks.icon(),
          onPressed: () {},
        ),
        Button(
          type: ButtonType.outlined,
          tintColor: context.theme.appColors.attentionRed,
          label: const Text('Outlined with Tint color'),
          mainAxisSize: MainAxisSize.max,
          leadingIcon: Assets.svg.iconBookmarks.icon(),
          onPressed: () {},
        ),
        Button(
          type: ButtonType.disabled,
          label: const Text('Disabled'),
          mainAxisSize: MainAxisSize.max,
          trailingIcon: Assets.svg.iconBookmarks.icon(),
          onPressed: () {},
        ),
        Button(
          label: const Text('Loading'),
          disabled: true,
          mainAxisSize: MainAxisSize.max,
          trailingIcon: const IceLoadingIndicator(),
          onPressed: () {},
        ),
        Button(
          label: Text(
            'Custom',
            style: context.theme.appTextThemes.caption.copyWith(
              color: context.theme.appColors.attentionRed,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: context.theme.appColors.onTerararyFill,
          ),
          mainAxisSize: MainAxisSize.max,
          trailingIcon: Assets.svg.iconBookmarks.icon(
            color: context.theme.appColors.attentionRed,
          ),
          onPressed: () {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'icon',
  type: Button,
)
Widget iconButtonUseCase(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Button.icon(
          icon: Assets.svg.iconHeaderMenu.icon(),
          onPressed: () {},
        ),
        Button.icon(
          type: ButtonType.outlined,
          icon: Assets.svg.iconHeaderMenu.icon(),
          onPressed: () {},
        ),
        Button.icon(
          size: 40.0.s,
          type: ButtonType.outlined,
          icon: Assets.svg.iconHeaderMenu.icon(
            size: 20.0.s,
          ),
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0.s)),
            ),
          ),
          onPressed: () {},
        ),
        Button.icon(
          size: 40.0.s,
          tintColor: context.theme.appColors.attentionRed,
          type: ButtonType.outlined,
          icon: Assets.svg.iconHeaderMenu.icon(
            size: 20.0.s,
          ),
          onPressed: () {},
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'compact',
  type: Button,
)
Widget compactButtonUseCase(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Button.compact(
                leadingIcon: Assets.svg.iconButtonReceive.icon(),
                label: Text(
                  context.knobs.string(
                    label: 'Label',
                    initialValue: 'Default',
                  ),
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              width: 16.0.s,
            ),
            Expanded(
              child: Button.compact(
                type: ButtonType.outlined,
                leadingIcon: Assets.svg.iconButtonSend.icon(),
                label: Text(
                  context.knobs.string(
                    label: 'Label',
                    initialValue: 'Default',
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'menu',
  type: Button,
)
Widget menuButtonUseCase(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Button.menu(
          onPressed: () {},
          leadingIcon: ButtonIconFrame(
            icon: Assets.svg.iconTabsCoins.icon(
              size: 20.0.s,
            ),
          ),
          label: const Text('Coins'),
        ),
        Button.menu(
          onPressed: () {},
          leadingIcon: ButtonIconFrame(
            color: context.theme.appColors.primaryAccent,
            icon: Assets.svg.iconTabsCoins.icon(
              size: 20.0.s,
              color: context.theme.appColors.secondaryBackground,
            ),
          ),
          label: const Text('Coins'),
          active: true,
        ),
        Button.menu(
          onPressed: () {},
          label: const Text('For you'),
        ),
        Button.menu(
          onPressed: () {},
          label: Text(
            'For you',
            style: TextStyle(color: context.theme.appColors.primaryAccent),
          ),
          active: true,
        ),
      ],
    ),
  );
}

@widgetbook.UseCase(
  name: 'dropdown',
  type: Button,
)
Widget dropdownButtonUseCase(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Button.dropdown(
          onPressed: () {},
          leadingIcon: ButtonIconFrame(
            color: context.theme.appColors.success,
            icon: Assets.svg.iconFeedStories.icon(
              size: 24.0.s,
              color: context.theme.appColors.secondaryBackground,
            ),
          ),
          label: const Text('News'),
        ),
        Button.dropdown(
          onPressed: () {},
          leadingIcon: ButtonIconFrame(
            color: context.theme.appColors.success,
            icon: Assets.svg.iconFeedStories.icon(
              size: 24.0.s,
              color: context.theme.appColors.secondaryBackground,
            ),
          ),
          label: const Text('News'),
          opened: true,
        ),
        Button.dropdown(
          onPressed: () {},
          leadingIcon: ButtonIconFrame(
            icon: Assets.svg.iconBadgeIcelogo.icon(size: 26.0.s),
          ),
          leadingIconOffset: 4.0.s,
          backgroundColor: context.theme.appColors.tertararyBackground,
          label: Text(
            'ice.wallet',
            style: TextStyle(color: context.theme.appColors.primaryText),
          ),
        ),
      ],
    ),
  );
}
