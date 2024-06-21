import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';

class FloatingAppBar extends StatelessWidget {
  FloatingAppBar({
    required this.child,
    required this.height,
    super.key,
    double? bottomOffset,
    double? topOffset,
  })  : bottomOffset = bottomOffset ?? UiSize.smallMedium,
        topOffset = topOffset ?? ScreenTopOffset.defaultMargin;

  final Widget child;
  final double height;
  final double bottomOffset;
  final double topOffset;

  @override
  Widget build(BuildContext context) {
    final safeAreaOffset = MediaQuery.paddingOf(context).top;
    final totalHeight = height + topOffset + bottomOffset + safeAreaOffset;
    final fadeOffset = topOffset + safeAreaOffset / 2;

    return SliverAppBar(
      elevation: 50,
      floating: true,
      pinned: true,
      automaticallyImplyLeading: false,
      expandedHeight: height + topOffset + bottomOffset,
      shadowColor:
          context.theme.appColors.onTertararyBackground.withOpacity(0.05),
      toolbarHeight: 0,
      backgroundColor: context.theme.appColors.onPrimaryAccent,
      surfaceTintColor: context.theme.appColors.onPrimaryAccent,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final opacity = 1 -
              ((totalHeight - constraints.maxHeight) / fadeOffset).clamp(0, 1);
          return Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: opacity.toDouble(),
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomOffset),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
