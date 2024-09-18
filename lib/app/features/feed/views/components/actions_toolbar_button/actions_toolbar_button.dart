import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/feed/data/models/toolbar.dart';

class ActionsToolbarButton extends StatelessWidget {
  const ActionsToolbarButton({
    required this.buttonType,
    required this.onPressed,
    this.buttonTypeSelected,
    this.selected = false,
  });

  final VoidCallback onPressed;
  final ActionsToolbarButtonType buttonType;
  final ActionsToolbarButtonType? buttonTypeSelected;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.only(right: 12.0.s),
        child: Container(
          height: 24.0.s,
          child: selected && buttonTypeSelected != null
              ? buttonTypeSelected!.iconAsset.icon(size: 24.0.s)
              : buttonType.iconAsset.icon(size: 24.0.s),
        ),
      ),
    );
  }
}
