import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
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
    final double extraBackWidth = showBackButton ? actionButtonSide : 0;
    final double extraActionsWidth = (actions != null && actions!.isNotEmpty)
        ? actions!.length * actionButtonSide
        : 0;

    return ScreenTopOffset(
      child: Container(
        color: context.theme.appColors.secondaryBackground,
        height: navigationHeaderHeight,
        child: ScreenSideOffset.small(
          child: Row(
            children: <Widget>[
              ColoredBox(
                color: Colors.blueGrey,
                child: SizedBox(
                  width: extraActionsWidth - extraBackWidth,
                  height: actionButtonSide,
                ),
              ),
              if (showBackButton)
                ColoredBox(
                  color: Colors.amber,
                  child: IconButton(
                    icon: Image.asset(
                      Assets.images.icons.iconBackArrow.path,
                      width: actionButtonSide,
                      height: actionButtonSide,
                    ),
                    onPressed: () {
                      if (onBackPress != null) {
                        onBackPress!();
                      } else {
                        context.pop();
                      }
                    },
                  ),
                )
              else
                ColoredBox(
                  color: Colors.amber,
                  child: SizedBox(width: actionButtonSide),
                ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.theme.appTextThemes.title,
                ),
              ),
              if (actions != null && actions!.isNotEmpty)
                Row(
                  children: actions!,
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
