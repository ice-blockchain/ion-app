// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class ContextMenuItem extends HookConsumerWidget {
  const ContextMenuItem({
    required this.label,
    required this.iconAsset,
    required this.onPressed,
    required this.onLayout,
    this.textColor,
    this.iconColor,
    super.key,
  });

  static double get iconSize => 20.0.s;

  final String label;
  final String iconAsset;
  final VoidCallback onPressed;
  final void Function(Size) onLayout;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalKey = useMemoized(GlobalKey.new);
    useOnInit(() {
      final renderBox = globalKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        onLayout(renderBox.size);
      }
    });

    final colors = context.theme.appColors;
    final textStyles = context.theme.appTextThemes;

    return GestureDetector(
      key: globalKey,
      onTap: onPressed,
      child: SizedBox(
        height: 44.0.s,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyles.subtitle3.copyWith(
                  color: textColor ?? colors.primaryText,
                ),
              ),
              SizedBox(
                width: 12.0.s,
              ),
              iconAsset.icon(
                size: iconSize,
                color: iconColor ?? colors.quaternaryText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
