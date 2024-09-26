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
  return Scaffold(
    backgroundColor: context.theme.appColors.primaryBackground,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavigationAppBar.screen(
            title: const Text('Some title'),
          ),
          NavigationAppBar.screen(
            title: const Text('Some title'),
            showBackButton: false,
            actions: [
              IconButton(
                icon: Assets.svg.iconSheetClose.icon(
                  size: NavigationAppBar.actionButtonSide,
                  color: context.theme.appColors.primaryText,
                ),
                onPressed: () {},
              ),
            ],
          ),
          NavigationAppBar.screen(
            title: const Text('Some title'),
            actions: [
              IconButton(
                icon: Assets.svg.iconChannelAdmin.icon(
                  size: NavigationAppBar.actionButtonSide,
                  color: context.theme.appColors.primaryText,
                ),
                onPressed: () {},
              ),
            ],
          ),
          NavigationAppBar.screen(
            title: const Text('Some title'),
            actions: [
              IconButton(
                icon: Assets.svg.iconChannelAdmin.icon(
                  size: NavigationAppBar.actionButtonSide,
                  color: context.theme.appColors.primaryText,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Assets.svg.iconMorePopup.icon(
                  size: NavigationAppBar.actionButtonSide,
                  color: context.theme.appColors.primaryText,
                ),
                onPressed: () {},
              ),
            ],
          ),
          NavigationAppBar.screen(
            title: const Text('Some very very long title'),
            actions: [
              IconButton(
                icon: Assets.svg.iconMorePopup.icon(
                  size: NavigationAppBar.actionButtonSide,
                  color: context.theme.appColors.primaryText,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
