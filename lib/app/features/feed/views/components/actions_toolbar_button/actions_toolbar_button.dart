import 'package:flutter/material.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

enum ActionsToolbarButtonType {
  gallery,
  camera,
  addFile,
  poll,
  schedule,
  regular,
  regularSelected,
  bold,
  boldSelected,
  italic,
  italicSelected;

  String get iconAsset => switch (this) {
        ActionsToolbarButtonType.gallery => Assets.svg.iconGalleryOpen,
        ActionsToolbarButtonType.camera => Assets.svg.iconCameraOpen,
        ActionsToolbarButtonType.addFile => Assets.svg.iconFeedAddfile,
        ActionsToolbarButtonType.poll => Assets.svg.iconPostPoll,
        ActionsToolbarButtonType.schedule => Assets.svg.iconCreatepostShedule,
        ActionsToolbarButtonType.regular => Assets.svg.iconPostRegulartextOff,
        ActionsToolbarButtonType.regularSelected => Assets.svg.iconPostRegulartextOn,
        ActionsToolbarButtonType.bold => Assets.svg.iconPostBoldtextOff,
        ActionsToolbarButtonType.boldSelected => Assets.svg.iconPostBoldtextOn,
        ActionsToolbarButtonType.italic => Assets.svg.iconPostItalictextOff,
        ActionsToolbarButtonType.italicSelected => Assets.svg.iconPostItalictextOn,
      };
}

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
