import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

double navigationHeaderHeight = 50.0.s;
double actionButtonSide = 24.0.s;

class NavigationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NavigationAppBar({
    required this.title,
    this.showBackButton = true,
    this.onBackPress,
    this.actions,
    super.key,
  });

  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPress;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final Widget leftItem = showBackButton
        ? IconButton(
            icon: Assets.images.icons.iconBackArrow.icon(
              size: actionButtonSide,
            ),
            onPressed: onBackPress ?? () => context.pop(),
          )
        : SizedBox(width: actionButtonSide);

    final List<Widget> rightItems = actions != null && actions!.isNotEmpty
        ? actions!
        : <Widget>[
            SizedBox(width: actionButtonSide),
          ];

    return ScreenTopOffset(
      child: Container(
        color: context.theme.appColors.secondaryBackground,
        height: navigationHeaderHeight,
        child: ScreenSideOffset.small(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[leftItem],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.theme.appTextThemes.title,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: rightItems,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(navigationHeaderHeight + ScreenTopOffset.defaultMargin);
}
