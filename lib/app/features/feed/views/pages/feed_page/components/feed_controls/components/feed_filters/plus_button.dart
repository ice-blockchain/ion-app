import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/generated/assets.gen.dart';

class PlusButton extends StatelessWidget {
  const PlusButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button.compact(
      onPressed: onPressed,
      type: ButtonType.menuInactive,
      label: ImageIcon(
        Assets.images.icons.iconPlusCreatechannel.provider(),
        size: 30.0.s,
        color: context.theme.appColors.primaryText,
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(48.0.s, 40.0.s),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
