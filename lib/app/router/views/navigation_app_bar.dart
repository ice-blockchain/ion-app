import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

double modalHeaderHeight = 60.0.s;
double screenHeaderHeight = 50.0.s;
double actionButtonSide = 24.0.s;

class NavigationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NavigationAppBar._({
    required this.title,
    this.showBackButton = true,
    this.onBackPress,
    this.actions,
    required this.useScreenTopOffset,
    super.key,
  });

  factory NavigationAppBar.screen({
    required String title,
    bool showBackButton = true,
    VoidCallback? onBackPress,
    List<Widget>? actions,
    Key? key,
  }) =>
      NavigationAppBar._(
        title: title,
        showBackButton: showBackButton,
        onBackPress: onBackPress,
        actions: actions,
        useScreenTopOffset: true,
        key: key,
      );

  factory NavigationAppBar.modal({
    required String title,
    bool showBackButton = true,
    VoidCallback? onBackPress,
    List<Widget>? actions,
    Key? key,
  }) =>
      NavigationAppBar._(
        title: title,
        showBackButton: showBackButton,
        onBackPress: onBackPress,
        actions: actions,
        useScreenTopOffset: false,
        key: key,
      );

  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPress;
  final List<Widget>? actions;
  final bool useScreenTopOffset;

  @override
  Widget build(BuildContext context) {
    final Widget appBarContent = Container(
      color: context.theme.appColors.secondaryBackground,
      height: useScreenTopOffset ? screenHeaderHeight : modalHeaderHeight,
      child: ScreenSideOffset.small(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  if (showBackButton)
                    IconButton(
                      icon: Assets.images.icons.iconBackArrow.icon(
                        size: actionButtonSide,
                      ),
                      onPressed: onBackPress ?? () => context.pop(),
                    )
                  else
                    SizedBox(width: actionButtonSide),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                textAlign: TextAlign.center,
                style: context.theme.appTextThemes.subtitle2
                    .copyWith(color: context.theme.appColors.primaryText),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:
                    actions ?? <Widget>[SizedBox(width: actionButtonSide)],
              ),
            ),
          ],
        ),
      ),
    );

    return useScreenTopOffset
        ? ScreenTopOffset(child: appBarContent)
        : appBarContent;
  }

  @override
  Size get preferredSize => useScreenTopOffset
      ? Size.fromHeight(screenHeaderHeight)
      : Size.fromHeight(modalHeaderHeight);
}
