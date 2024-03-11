import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/views/navigation_app_bar.dart';
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
        const NavigationAppBar(
          title: 'Some title',
        ),
        NavigationAppBar(
          title: 'Some title',
          showBackButton: false,
          actions: <Widget>[
            IconButton(
              icon: Assets.images.icons.iconSheetClose.icon(
                size: actionButtonSide,
                color: context.theme.appColors.primaryText,
              ),
              onPressed: () {},
            ),
          ],
        ),
        NavigationAppBar(
          title: 'Some title',
          actions: <Widget>[
            IconButton(
              icon: Assets.images.icons.iconChannelAdmin.icon(
                size: actionButtonSide,
                color: context.theme.appColors.primaryText,
              ),
              onPressed: () {},
            ),
          ],
        ),
        NavigationAppBar(
          title: 'Some title',
          actions: <Widget>[
            IconButton(
              icon: Assets.images.icons.iconMorePopup.icon(
                size: actionButtonSide,
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
