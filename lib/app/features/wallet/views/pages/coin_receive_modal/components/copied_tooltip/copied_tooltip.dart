import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/painters/triangle_painter.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/hooks/use_on_init.dart';

class CopiedTooltip extends HookConsumerWidget {
  const CopiedTooltip({
    super.key,
    required this.onLayout,
  });

  final Function(Size) onLayout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey tooltipKey = GlobalKey();

    useOnInit(() {
      final RenderBox? renderBox =
          tooltipKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        onLayout(renderBox.size);
      }
    });

    return Column(
      children: <Widget>[
        Container(
          key: tooltipKey,
          height: 22.0.s,
          padding: EdgeInsets.symmetric(
            horizontal: 6.0.s,
          ),
          decoration: BoxDecoration(
            color: context.theme.appColors.primaryText,
            borderRadius: BorderRadius.circular(8.0.s),
          ),
          alignment: Alignment.center,
          child: Text(
            context.i18n.wallet_copied,
            style: context.theme.appTextThemes.caption2.copyWith(
              color: context.theme.appColors.primaryBackground,
            ),
          ),
        ),
        CustomPaint(
          size: Size(7.0.s, 5.0.s),
          painter: TrianglePainter(
            color: context.theme.appColors.primaryText,
          ),
        ),
      ],
    );
  }
}
