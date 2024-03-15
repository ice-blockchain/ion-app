import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class NavigationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NavigationAppBar._({
    this.title = '',
    this.showBackButton = true,
    this.onBackPress,
    this.actions,
    required this.useScreenTopOffset,
    super.key,
  });

  factory NavigationAppBar.screen({
    String title = '',
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
    String title = '',
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

  static double get modalHeaderHeight => 60.0.s;
  static double get screenHeaderHeight => 42.0.s;
  static double get actionButtonSide => 24.0.s;

  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPress;
  final List<Widget>? actions;
  final bool useScreenTopOffset;

  @override
  Widget build(BuildContext context) {
    final Widget appBarContent = NavigationToolbar(
      leading: showBackButton
          ? GestureDetector(
              onTap: onBackPress ?? () => context.pop(),
              child: Assets.images.icons.iconBackArrow
                  .icon(size: actionButtonSide),
            )
          : null,
      middle: Text(
        title,
        style: context.theme.appTextThemes.subtitle2
            .copyWith(color: context.theme.appColors.primaryText),
      ),
      trailing: actions != null && actions!.isNotEmpty
          ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
          : null,
    );

    final Widget appBar = Container(
      color: context.theme.appColors.secondaryBackground,
      height: useScreenTopOffset ? screenHeaderHeight : modalHeaderHeight,
      child: ScreenSideOffset.small(child: appBarContent),
    );

    return useScreenTopOffset ? ScreenTopOffset(child: appBar) : appBar;
  }

  @override
  Size get preferredSize => Size.fromHeight(
        useScreenTopOffset ? screenHeaderHeight : modalHeaderHeight,
      );
}
