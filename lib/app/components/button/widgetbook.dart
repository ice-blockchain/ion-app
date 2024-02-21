import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';
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
      children: <Widget>[
        Button(
          label: Text(
            context.knobs.string(
              label: 'Label',
              initialValue: 'Default',
            ),
          ),
          mainAxisSize: MainAxisSize.max,
          leadingIcon: ButtonIcon(Assets.images.icons.iconBookmarks.path),
          onPressed: () {},
        ),
        Button(
          type: ButtonType.secondary,
          label: const Text('Secondary'),
          mainAxisSize: MainAxisSize.max,
          trailingIcon: ButtonIcon(Assets.images.icons.iconBookmarks.path),
          onPressed: () {},
        ),
        Button(
          type: ButtonType.outlined,
          label: const Text('Outlined'),
          mainAxisSize: MainAxisSize.max,
          leadingIcon: ButtonIcon(Assets.images.icons.iconBookmarks.path),
          onPressed: () {},
        ),
        Button(
          type: ButtonType.outlined,
          tintColor: context.theme.appColors.attentionRed,
          label: const Text('Outlined with Tint color'),
          mainAxisSize: MainAxisSize.max,
          leadingIcon: ButtonIcon(Assets.images.icons.iconBookmarks.path),
          onPressed: () {},
        ),
        Button(
          type: ButtonType.disabled,
          label: const Text('Disabled'),
          mainAxisSize: MainAxisSize.max,
          trailingIcon: ButtonIcon(Assets.images.icons.iconBookmarks.path),
          onPressed: () {},
        ),
        Button(
          label: const Text('Loading'),
          disabled: true,
          mainAxisSize: MainAxisSize.max,
          trailingIcon: const ButtonLoadingIndicator(),
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
          trailingIcon: ImageIcon(
            AssetImage(Assets.images.icons.iconBookmarks.path),
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
      children: <Widget>[
        Button.icon(
          icon: ImageIcon(
            AssetImage(Assets.images.icons.iconHeaderMenu.path),
          ),
          onPressed: () {},
        ),
        Button.icon(
          type: ButtonType.outlined,
          icon: ImageIcon(
            AssetImage(Assets.images.icons.iconHeaderMenu.path),
          ),
          onPressed: () {},
        ),
        Button.icon(
          size: 40.0.s,
          type: ButtonType.outlined,
          icon: ImageIcon(
            AssetImage(Assets.images.icons.iconHeaderMenu.path),
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
          icon: ImageIcon(
            AssetImage(Assets.images.icons.iconHeaderMenu.path),
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
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Button.compact(
                leadingIcon: ImageIcon(
                  AssetImage(Assets.images.icons.iconButtonReceive.path),
                ),
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
                leadingIcon: ImageIcon(
                  AssetImage(Assets.images.icons.iconButtonSend.path),
                ),
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
      children: <Widget>[
        Button.menu(
          onPressed: () {},
          leadingIcon: ButtonFramedIcon(
            icon: ButtonIcon(
              Assets.images.icons.iconTabsCoins.path,
              size: 20.0.s,
            ),
          ),
          label: const Text('Coins'),
        ),
        Button.menu(
          onPressed: () {},
          leadingIcon: ButtonFramedIcon(
            color: context.theme.appColors.primaryAccent,
            icon: ButtonIcon(
              Assets.images.icons.iconTabsCoins.path,
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
      children: <Widget>[
        Button.dropdown(
          onPressed: () {},
          leadingIcon: ButtonFramedIcon(
            color: context.theme.appColors.success,
            icon: ButtonIcon(
              Assets.images.icons.iconFeedStories.path,
              size: 24.0.s,
              color: context.theme.appColors.secondaryBackground,
            ),
          ),
          label: const Text('News'),
        ),
        Button.dropdown(
          onPressed: () {},
          leadingIcon: ButtonFramedIcon(
            color: context.theme.appColors.success,
            icon: ButtonIcon(
              Assets.images.icons.iconFeedStories.path,
              size: 24.0.s,
              color: context.theme.appColors.secondaryBackground,
            ),
          ),
          label: const Text('News'),
          opened: true,
        ),
        Button.dropdown(
          onPressed: () {},
          leadingIcon: ButtonFramedIcon(
            icon: Image(
              width: 26.0.s,
              height: 26.0.s,
              fit: BoxFit.fill,
              image: AssetImage(Assets.images.icons.iconBadgeIcelogo.path),
            ),
          ),
          leadingButtonOffset: 4.0.s,
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
