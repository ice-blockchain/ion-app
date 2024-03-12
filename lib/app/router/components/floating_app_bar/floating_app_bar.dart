import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_top_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';

class FloatingAppBar extends StatelessWidget {
  FloatingAppBar({
    super.key,
    required this.child,
    required this.height,
    double? bottomOffset,
    double? topOffset,
  })  : bottomOffset = bottomOffset ?? 10.0.s,
        topOffset = topOffset ?? ScreenTopOffset.defaultMargin;

  final Widget child;
  final double height;
  final double bottomOffset;
  final double topOffset;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 50,
      floating: true,
      automaticallyImplyLeading: false,
      shadowColor:
          context.theme.appColors.onTertararyBackground.withOpacity(0.05),
      toolbarHeight: height + topOffset + bottomOffset,
      backgroundColor: context.theme.appColors.onPrimaryAccent,
      surfaceTintColor: context.theme.appColors.onPrimaryAccent,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return ScreenTopOffset(margin: topOffset, child: child);
        },
      ),
    );
  }
}
