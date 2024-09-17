import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/data/models/toolbar.dart';
import 'package:ice/app/features/feed/views/components/toolbar_text/toolbar_text.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({
    this.padding,
    this.toolbarType = ToolbarType.post,
    this.onButtonTap,
    super.key,
  });

  final EdgeInsets? padding;
  final ToolbarType toolbarType;
  final ValueChanged<ToolbarButtonType>? onButtonTap;

  @override
  Widget build(BuildContext context) {
    final toolbarButtons = toolbarType.buttons;

    return ScreenSideOffset.small(
      child: Container(
        height: 40.0.s,
        padding: padding,
        child: Row(
          children: [
            ...toolbarButtons
                .map((buttonType) => switch (buttonType) {
                      ToolbarButtonType.spacer => const Spacer(),
                      ToolbarButtonType.font => ToolbarText(
                          onTextStyleChange: (ToolbarTextButtonType type) => {},
                        ),
                      _ => Padding(
                          padding: EdgeInsets.only(right: 12.0.s),
                          child: _ToolbarButton(buttonType: buttonType, onButtonTap: onButtonTap),
                        ),
                    })
                .toList(),
          ],
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final ToolbarButtonType buttonType;
  final ValueChanged<ToolbarButtonType>? onButtonTap;

  const _ToolbarButton({
    required this.buttonType,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonHeight = buttonType == ToolbarButtonType.send ? 28.0.s : 24.0.s;

    return GestureDetector(
      onTap: onButtonTap != null ? () => onButtonTap!(buttonType) : null,
      child: Container(
        height: buttonHeight,
        alignment: buttonType == ToolbarButtonType.send ? Alignment.center : null,
        child: buttonType.iconAsset != null ? buttonType.iconAsset!.icon(size: buttonHeight) : null,
      ),
    );
  }
}
