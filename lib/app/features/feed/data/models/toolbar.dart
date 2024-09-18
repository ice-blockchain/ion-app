import 'package:ice/generated/assets.gen.dart';

enum ActionsToolbarButtonType {
  gallery,
  poll,
  schedule,
  send,
  regular,
  regularSelected,
  bold,
  boldSelected,
  italic,
  italicSelected;

  String get iconAsset => switch (this) {
        ActionsToolbarButtonType.gallery => Assets.svg.iconGalleryOpen,
        ActionsToolbarButtonType.poll => Assets.svg.iconPostPoll,
        ActionsToolbarButtonType.send => Assets.svg.sendbuttonDisabled,
        ActionsToolbarButtonType.schedule => Assets.svg.iconCreatepostShedule,
        ActionsToolbarButtonType.regular => Assets.svg.iconPostRegulartextOff,
        ActionsToolbarButtonType.regularSelected => Assets.svg.iconPostRegulartextOn,
        ActionsToolbarButtonType.bold => Assets.svg.iconPostBoldtextOff,
        ActionsToolbarButtonType.boldSelected => Assets.svg.iconPostBoldtextOn,
        ActionsToolbarButtonType.italic => Assets.svg.iconPostItalictextOff,
        ActionsToolbarButtonType.italicSelected => Assets.svg.iconPostItalictextOn,
      };
}
