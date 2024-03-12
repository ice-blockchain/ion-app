import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/generated/assets.gen.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'regular',
  type: NavigationAppBar,
)
Widget regularNavigationAppBarUseCase(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        NavigationAppBar.screen(
          title: 'Some title',
        ),
        NavigationAppBar.screen(
          title: 'Some title',
          showBackButton: false,
          actions: <Widget>[
            IconButton(
              icon: Assets.images.icons.iconSheetClose.icon(
                size: NavigationAppBar.actionButtonSide,
                color: context.theme.appColors.primaryText,
              ),
              onPressed: () {},
            ),
          ],
        ),
        NavigationAppBar.screen(
          title: 'Some title',
          actions: <Widget>[
            IconButton(
              icon: Assets.images.icons.iconChannelAdmin.icon(
                size: NavigationAppBar.actionButtonSide,
                color: context.theme.appColors.primaryText,
              ),
              onPressed: () {},
            ),
          ],
        ),
        NavigationAppBar.screen(
          title: 'Some title',
          actions: <Widget>[
            IconButton(
              icon: Assets.images.icons.iconChannelAdmin.icon(
                size: NavigationAppBar.actionButtonSide,
                color: context.theme.appColors.primaryText,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Assets.images.icons.iconMorePopup.icon(
                size: NavigationAppBar.actionButtonSide,
                color: context.theme.appColors.primaryText,
              ),
              onPressed: () {},
            ),
          ],
        ),
        NavigationAppBar.screen(
          title: 'Some very very long title',
          actions: <Widget>[
            IconButton(
              icon: Assets.images.icons.iconMorePopup.icon(
                size: NavigationAppBar.actionButtonSide,
                color: context.theme.appColors.primaryText,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    ),
  );
}
