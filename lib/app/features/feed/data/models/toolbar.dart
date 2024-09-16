import 'package:ice/generated/assets.gen.dart';

enum ToolbarType {
  post,
  article;

  List<ToolbarButtonType> get buttons {
    switch (this) {
      case ToolbarType.post:
        return [
          ToolbarButtonType.gallery,
          ToolbarButtonType.poll,
          ToolbarButtonType.font,
          ToolbarButtonType.spacer,
          ToolbarButtonType.schedule,
          ToolbarButtonType.send,
        ];
      case ToolbarType.article:
        return [
          ToolbarButtonType.gallery,
          ToolbarButtonType.font,
          ToolbarButtonType.spacer,
          ToolbarButtonType.send,
        ];
    }
  }
}

enum ToolbarButtonType {
  gallery,
  poll,
  font,
  spacer,
  schedule,
  send;

  String? get iconAsset {
    switch (this) {
      case ToolbarButtonType.gallery:
        return Assets.svg.iconGalleryOpen;
      case ToolbarButtonType.poll:
        return Assets.svg.iconPostPoll;
      case ToolbarButtonType.send:
        return Assets.svg.sendbuttonDisabled;
      case ToolbarButtonType.schedule:
        return Assets.svg.iconCreatepostShedule;
      case ToolbarButtonType.spacer:
      case ToolbarButtonType.font:
        return null;
    }
  }
}

enum ToolbarTextButtonType {
  regular,
  bold,
  italic;

  String getIconAsset(bool isSelected) {
    switch (this) {
      case ToolbarTextButtonType.regular:
        return isSelected ? Assets.svg.iconPostRegulartextOn : Assets.svg.iconPostRegulartextOff;
      case ToolbarTextButtonType.bold:
        return isSelected ? Assets.svg.iconPostBoldtextOn : Assets.svg.iconPostBoldtextOff;
      case ToolbarTextButtonType.italic:
        return isSelected ? Assets.svg.iconPostItalictextOn : Assets.svg.iconPostItalictextOff;
    }
  }
}
