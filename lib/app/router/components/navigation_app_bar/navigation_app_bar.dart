// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/constants/ui.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_back_button.dart';

class NavigationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NavigationAppBar({
    required this.useScreenTopOffset,
    this.title,
    this.showBackButton = true,
    this.hideKeyboardOnBack = false,
    this.onBackPress,
    this.actions,
    this.leading,
    super.key,
  });

  factory NavigationAppBar.screen({
    Widget? title,
    bool showBackButton = true,
    VoidCallback? onBackPress,
    List<Widget>? actions,
    Key? key,
  }) =>
      NavigationAppBar(
        title: title,
        showBackButton: showBackButton,
        onBackPress: onBackPress,
        actions: actions,
        useScreenTopOffset: true,
        key: key,
      );

  factory NavigationAppBar.modal({
    Widget? title,
    bool showBackButton = true,
    VoidCallback? onBackPress,
    List<Widget>? actions,
    bool hideKeyboardOnBack = true,
    Widget? leading,
    Key? key,
  }) =>
      NavigationAppBar(
        title: title,
        showBackButton: showBackButton,
        onBackPress: onBackPress,
        actions: actions,
        useScreenTopOffset: false,
        hideKeyboardOnBack: hideKeyboardOnBack,
        leading: leading,
        key: key,
      );

  static double get modalHeaderHeight => 60.0.s;

  static double get screenHeaderHeight => 56.0.s;

  static double get actionButtonSide => 24.0.s;

  final Widget? title;
  final bool showBackButton;
  final bool hideKeyboardOnBack;
  final VoidCallback? onBackPress;
  final List<Widget>? actions;
  final bool useScreenTopOffset;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final Widget? titleWidget = title != null
        ? DefaultTextStyle(
            textAlign: TextAlign.center,
            style: context.theme.appTextThemes.subtitle
                .copyWith(color: context.theme.appColors.primaryText),
            child: title!,
          )
        : null;
    final Widget appBarContent = NavigationToolbar(
      leading: leading ??
          (showBackButton
              ? NavigationBackButton(
                  onBackPress ?? context.pop,
                  hideKeyboardOnBack: hideKeyboardOnBack,
                )
              : null),
      middle: titleWidget,
      trailing: actions != null && actions!.isNotEmpty
          ? Row(mainAxisSize: MainAxisSize.min, children: actions!)
          : null,
    );

    final Widget appBar = Container(
      color: context.theme.appColors.secondaryBackground,
      height: useScreenTopOffset ? screenHeaderHeight : modalHeaderHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSideOffset.defaultSmallMargin - UiConstants.hitSlop,
        ),
        child: appBarContent,
      ),
    );

    return useScreenTopOffset
        ? ScreenTopOffset(
            margin: 0,
            child: appBar,
          )
        : appBar;
  }

  @override
  Size get preferredSize => Size.fromHeight(
        useScreenTopOffset ? screenHeaderHeight : modalHeaderHeight,
      );
}
